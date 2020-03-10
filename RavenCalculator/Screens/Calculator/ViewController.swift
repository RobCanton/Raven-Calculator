//
//  ViewController.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-02-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    var tableView:UITableView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var equation = Equation()

    var contentView:UIView!
    var contentViewBottomAnchor:NSLayoutConstraint!
    
    var currentWordRange:UITextRange?
    var currentWord:String?
    
    var accessoryView:RavenAccessoryView!
    
    var results = [Symbol]()
    
    var showStats = false
    
    let fuse = Fuse(location: 0,
        distance: 100,
        threshold: 0.3,
        maxPatternLength: 32,
        isCaseSensitive: false)
    
    let stats:[Stat] = Stat.all
    
    var visibleStats = [Stat]()
    
    var equationView:EquationView!
    var evaluationView:EvaluationView!
    var evaluationTopAnchor:NSLayoutConstraint!
    let evaluationHeight:CGFloat = 56
    
    var textView:UITextView? {
        equationView?.textView
    }
    
    
    var toolboxView:UIView?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visibleStats = stats
        contentView = UIView()
        view.addSubview(contentView)
        contentView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        contentViewBottomAnchor.isActive = true
        
        equationView = EquationView()
        contentView.addSubview(equationView)
        equationView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
        textView?.delegate = self
        
        evaluationView = EvaluationView()
        contentView.insertSubview(evaluationView, belowSubview: equationView)
        evaluationView.constraintHeight(to: evaluationHeight)
        evaluationView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        evaluationTopAnchor = evaluationView.topAnchor.constraint(equalTo: equationView.bottomAnchor, constant: -evaluationHeight)
        evaluationTopAnchor.isActive = true
        
        
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        
        contentView.addSubview(tableView)
        tableView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        tableView.topAnchor.constraint(equalTo: evaluationView.bottomAnchor).isActive = true
        //tableView.register(TextViewCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(PredictionResultCell.self, forCellReuseIdentifier: "resultCell")
        tableView.register(PredictionsTableCell.self, forCellReuseIdentifier: "predictionsCell")
        tableView.backgroundColor = UIColor.secondarySystemGroupedBackground
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        
        accessoryView = RavenAccessoryView()
        contentView.addSubview(accessoryView)
        accessoryView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        
        accessoryView.operationsView.delegate = self
        /*
        accessoryView.statsView.delegate = self
        accessoryView.predictionsView.delegate = self
        */
        tableView.bottomAnchor.constraint(equalTo: accessoryView.topAnchor).isActive = true
        view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:
            UIResponder.keyboardWillHideNotification, object: nil)
        
        textView?.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        contentViewBottomAnchor.constant = -keyboardSize.height
        view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        contentViewBottomAnchor.constant = 0
        view.layoutIfNeeded()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        //let lastIndex = IndexPath(row: 0, section: 0)
        //tableView.scrollToRow(at: lastIndex, at: .top, animated: true)
        
        let components = parse(textView.attributedText.string)
        equationView.updateSyntax(for: components)
        //equation.printAll()
        currentWordRange = textView.currentWordRange

        if currentWordRange != nil,
            let text = textView.text(in: currentWordRange!),
            !text.isEmpty {
            currentWord = text
        } else {
            currentWord = nil
        }
        
        
        guard currentWord != nil, !currentWord!.isEmpty else {
            self.showStats = false
            self.results = []
            self.reloadTable()
            return
        }
        
        if currentWord!.contains(":") {
            
            let split = currentWord!.split(separator: ":")
            if split.count == 2 {
                let query = String(split[1])
                
                DispatchQueue.main.async {
                    
                    self.fuse.search(query, in: self.stats) { searchResults in
                        
                        var _visibleStats = [Stat]()
                        for result in searchResults {
                            _visibleStats.append(self.stats[result.index])
                        }

                        self.visibleStats = _visibleStats
                        self.reloadTable()
                    }
                }
                
            } else {
                visibleStats = stats
            }
            
            self.showStats = true
            self.reloadTable()
            
        } else {
            self.showStats = false
            self.reloadTable()
            IEXCloudAPI.shared.searchSymbols(currentWord!) { query, results in
                if query != self.currentWord {
                    return
                }
                
                self.results = results
                self.reloadTable()
                
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            evaluate()
            return false
        }
        
//        if text.isOperation {
//            let currentText = textView.attributedText.string
//            if currentText.last != " " && currentText.last != nil {
//                textView.text += " \(text)"
//                textViewDidChange(textView)
//                return false
//            }
//            return true
//        }
        
        return true
        var cursor = 0
        if let selectedRange = textView.selectedTextRange {
            cursor = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        }
        
        print("\(cursor)")
        
        if text == "\n" {
            evaluate()
            return false
        }
        
        if text == "" {
            if range.length > 0 {
                for _ in 0..<range.length {
                    equation.removeComponent()
                }
            }
            return true
        }
        
        let components = equation.process(text: text, cursor: cursor)
        print("Components to add: \(components)")
        updateTextView(textView, withComponents: components, cursor: cursor)
         
        return false
    }
    
    func reloadTable() {
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func updateTextView(_ textView:UITextView, withComponents components:[Component], cursor:Int) {
        var totalLengthAdded = 0
        for component in components {
            if let lastFragment = component.lastFragment {
                if lastFragment == ":" {
                    visibleStats = stats
                }
                    
                let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
            
                attributedText.insert(NSAttributedString(string: lastFragment, attributes: component.type.styleAttributes), at: cursor)
                totalLengthAdded += lastFragment.count
                textView.attributedText = attributedText
            }
        }
        
        UIView.setAnimationsEnabled(false)
        textView.sizeToFit()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        let newPosition = textView.position(from: textView.beginningOfDocument, offset: cursor + totalLengthAdded)!
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        
        textViewDidChange(textView)
    }
    
    func evaluate() {
        print("evaluate")
        let evaluator = Evaluator(equation: equation, delegate: self)
        evaluator.solve()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return showStats ? visibleStats.count : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! PredictionResultCell
        if showStats {
            cell.titleLabel?.text = visibleStats[indexPath.row].rawValue
            cell.subtitleLabel?.text = nil
        } else {
            cell.titleLabel?.text = results[indexPath.row].symbol
            cell.subtitleLabel?.text = results[indexPath.row].securityName
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let currentWordRange = self.currentWordRange else { return }
        if showStats {
            /*
            //extView?.text?.append("\(visibleStats[indexPath.row].key) ")
            //self.reloadTable()
            
            let stat = visibleStats[indexPath.row]
            
            let removedComponent = equation.removeComponent(forced: true)
            
            var statComponents = equation.process(text: ":")
            statComponents.append(contentsOf: equation.process(text: stat.rawValue))
            statComponents.append(contentsOf: equation.process(text: " "))
            
            if let textView = self.textView {
                
                let removeRange = textView.getRange(from: currentWordRange.end,
                                                    offset: -removedComponent!.string.count)
                
                textView.replace(removeRange!, withText: "")
                
                updateTextView(textView, withComponents: statComponents)
            }
            showStats = false
            self.reloadTable()
            */
            return
        }
        let symbol = results[indexPath.row]
        
        let removedComponent = equation.removeComponent(forced: true)
        /*
        var symbolComponents = equation.process(text: "\(symbol.symbol)")
        let statComponents = equation.process(text: ":")
        symbolComponents.append(contentsOf: statComponents)
        if let textView = self.textView {
            
            let removeRange = textView.getRange(from: currentWordRange.end,
                                                offset: -removedComponent!.string.count)
            
            textView.replace(removeRange!, withText: "")
            
            
            updateTextView(textView, withComponents: symbolComponents)
        }
        results = []
        self.reloadTable()
        */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 56
    }
    
    
}

extension ViewController: OperationsAccessoryDelegate {
    func operationsAccessory(didSelect operation: Operation) {
        
        guard let textView = self.textView else { return }
        if operation == .keyboard {
            if textView.keyboardType == .alphabet {
                textView.keyboardType = .decimalPad
            } else {
                textView.keyboardType = .alphabet
            }
            textView.reloadInputViews()
            
            return
        }
        
        textView.insertText(" \(operation.textRepresentable) ")
        /*
        let components = equation.process(text: operation.textRepresentable)
        
        updateTextView(textView, withComponents: components)
        */
    }
}

extension ViewController: EvaluatorDelegate {
    
    func evaluatorDidStart() {
        print("evaluatorDidStart")
        
        evaluationView.startSolving()
        
        let animator = UIViewPropertyAnimator(duration: 0.25, timingParameters: Easings.Quart.easeOut)
        animator.addAnimations {
            self.evaluationTopAnchor.constant = -(self.evaluationHeight - EvaluationView.loadingBarHeight)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func evaluatorDidComplete(withResult result: Evaluation) {
        print("evaluatorDidComplete withResult: \(result)")
        self.evaluationView.setEvaluation(result)
        
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Easings.Quart.easeOut)
        animator.addAnimations {
            self.evaluationTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func evaluatorDidFail(withError error: Error) {
        print("evaluatorDidFail withError: \(error.localizedDescription)")
    }
    
}
