//
//  ViewController.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-02-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

class EquationViewController: UIViewController, UITextViewDelegate {
    
    // Model
    var item:Item?
    var details:ItemDetails
    var equation:Equation
    var evaluation:Evaluation?
    var mode:TableMode
    
    var symbols:[Symbol]

    let stats:[Stat] = Stat.all
    var visibleStats:[Stat]
    
    var editingChanged:Bool
    
    let fuse = Fuse(location: 0,
                    distance: 100,
                    threshold: 0.3,
                    maxPatternLength: 32,
                    isCaseSensitive: false)
    
    enum TableMode {
        case symbols, stats, details
    }
    
    
    init(item:Item?=nil) {
        self.item = item
        self.details = item?.details ?? ItemDetails()
        
        self.equation = item?.equation ?? Equation()
        self.mode = item == nil ? .symbols : .details
        self.symbols = []
        self.visibleStats = stats
        self.editingChanged = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.details = ItemDetails()
        self.equation = Equation()
        self.mode = .symbols
        self.symbols = []
        self.visibleStats = stats
        self.editingChanged = false
        super.init(nibName: nil, bundle: nil)
    }
       
    
    // View
    var contentView:UIView!
    var contentViewBottomAnchor:NSLayoutConstraint!
    
    var tableView:UITableView!
    
    var accessoryView:RavenAccessoryView!
    var accessoryBottomAnchor:NSLayoutConstraint!
    
    var equationView:EquationView!
    
    var evaluationView:EvaluationView!
    var evaluationTopAnchor:NSLayoutConstraint!
    let evaluationHeight:CGFloat = 56
    var equationDivider:UIView!
    
    var saveButton:UIBarButtonItem!
    var savingButton:UIBarButtonItem!
    
    var textView:UITextView? {
        return equationView?.textView
    }
    
    var getCursor:Int {
        var cursor = 0
        if let selectedRange = textView?.selectedTextRange {
            cursor = textView!.offset(from: textView!.beginningOfDocument, to: selectedRange.start)
        }
        return cursor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                                                   target: self,
                                                                   action: #selector(handleSave))
        saveButton.isEnabled = false
        
        savingButton = UIBarButtonItem(title: "Saving...", style: .plain, target: nil, action: nil)
        savingButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = saveButton
        
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.secondarySystemGroupedBackground
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.systemPink
        
        self.navigationController?.presentationController?.delegate = self
        equation.delegate = self
        
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
        
        equationDivider = UIView()
        equationDivider.backgroundColor = UIColor(hex: "3E3E3F")
        view.addSubview(equationDivider)
        equationDivider.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        equationDivider.topAnchor.constraint(equalTo: evaluationView.bottomAnchor).isActive = true
        equationDivider.constraintHeight(to: 0.5)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        
        contentView.addSubview(tableView)
        tableView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        tableView.topAnchor.constraint(equalTo: evaluationView.bottomAnchor).isActive = true
        tableView.register(PredictionResultCell.self, forCellReuseIdentifier: "resultCell")
        tableView.register(PredictionsTableCell.self, forCellReuseIdentifier: "predictionsCell")
        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: "nameCell")
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "tagsCell")
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.register(WatchLevelTableViewCell.self, forCellReuseIdentifier: "watchLevelCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "newAlertCell")
        tableView.backgroundColor = UIColor(hex: "161617")
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        
        accessoryView = RavenAccessoryView()
        contentView.addSubview(accessoryView)
        accessoryView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        accessoryBottomAnchor = accessoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        accessoryBottomAnchor.isActive = true
        
        accessoryBottomAnchor.constant = 44
        
        accessoryView.operationsView.delegate = self
        /*
        accessoryView.statsView.delegate = self
        accessoryView.predictionsView.delegate = self
        */
        tableView.bottomAnchor.constraint(equalTo: accessoryView.topAnchor).isActive = true
        view.layoutIfNeeded()
        
        equationView.updateSyntax(for: equation.components)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:
            UIResponder.keyboardWillHideNotification, object: nil)
        
        if self.item == nil {
            textView?.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        self.view.isUserInteractionEnabled = false
        navigationItem.setRightBarButton(savingButton, animated: true)
        
        //let id = self.item?.id ?? UUID()
        
        let newItem = Item(id: self.item?.id ?? "",
                        equation: equation,
                        evaluation: evaluation,
                        details: details)
        
        RavenAPI.shared.saveItem(newItem) { error in
            print("didSaveItem withError: \(error?.localizedDescription ?? "nil")")
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        
        //ItemManager.shared.addItem(newItem)
        
        
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        contentViewBottomAnchor.constant = -keyboardSize.height
        if mode == .symbols || mode == .stats {
            accessoryBottomAnchor.constant = 0
        }
        view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        contentViewBottomAnchor.constant = 0
        accessoryBottomAnchor.constant = 44
        view.layoutIfNeeded()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if mode == .details {
            mode = .symbols
            UIView.animate(withDuration: 0.25, animations: {
                self.accessoryBottomAnchor.constant = 0
                self.view.layoutIfNeeded()
            })
            
            self.tableView.reloadData()
        }
        
        let cursor = getCursor
        
        hideEvaluator()
        
        equation.process(text: textView.attributedText.string)
        equationView.updateSyntax(for: equation.components)

        if let newPosition = textView.position(from: textView.beginningOfDocument, offset: cursor) {
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
        
        guard let currentComponentIndex = equation.componentIndex(at: cursor) else {
            self.mode = .symbols
            self.symbols = []
            self.reloadTable()
            return
        }
        
        let currentComponent = equation.components[currentComponentIndex]
        
        if currentComponent.type == .stat {
            let query = currentComponent.string.replacingOccurrences(of: ":", with: "")
            if query.isEmpty {
                visibleStats = stats
            } else {
                self.fuse.search(query, in: self.stats) { searchResults in
                    
                    var _visibleStats = [Stat]()
                    for result in searchResults {
                        _visibleStats.append(self.stats[result.index])
                    }

                    self.visibleStats = _visibleStats
                    self.reloadTable()
                }
            }
            
            self.mode = .stats
            self.reloadTable()
        } else if currentComponent.type == .symbol {
            self.mode = .symbols
            self.reloadTable()
            
            IEXCloudAPI.shared.searchSymbols(currentComponent.string) { query, results in
                if query != currentComponent.string {
                    return
                }
                
                self.symbols = results
                self.reloadTable()
                
            }
        } else {
            self.mode = .symbols
            self.symbols = []
            self.reloadTable()
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            evaluate()
            return false
        }
        return true
    }
    
    func reloadTable() {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func evaluate() {
        let evaluator = Evaluator(equation: equation, delegate: self)
        evaluator.solve()
    }
    
}

extension EquationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch mode {
        case .details:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .symbols:
            return symbols.count
        case .stats:
            return visibleStats.count
        case .details:
            switch section {
            case 0:
                return 4
            case 1:
                return 1
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mode {
        case .symbols:
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! PredictionResultCell
            cell.titleLabel?.text = symbols[indexPath.row].symbol
            cell.subtitleLabel?.text = symbols[indexPath.row].securityName
            return cell
        case .stats:
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! PredictionResultCell
            cell.titleLabel?.text = visibleStats[indexPath.row].rawValue
            cell.subtitleLabel?.text = nil
            return cell
        case .details:
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
                    cell.textField.text = details.name
                    cell.delegate = self
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as! TagsTableViewCell
                    cell.textField.text = details.tagsStr
                    cell.delegate = self
                    cell.separatorInset = .zero
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "watchLevelCell", for: indexPath) as! WatchLevelTableViewCell
                    cell.setWatchLevel(details.watchLevel)
                    cell.delegate = self
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! EmptyTableViewCell
                    return cell
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "newAlertCell", for: indexPath)
                    cell.textLabel?.text = "New Alert"
                    cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
                    cell.accessoryType = .disclosureIndicator
                    cell.backgroundColor = UIColor(hex: "1D1D1E")
                    cell.separatorInset = .zero
                    return cell
                default:
                    break
                }
                break
            default:
                break
            }
            
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let textView = self.textView else { return }
        
        let cursor = getCursor
        
        switch mode {
        case .symbols:
            let symbol = symbols[indexPath.row]
            
            if let componentIndex = equation.componentIndex(at: cursor) {
                equation.removeComponent(at: componentIndex)
                equation.insertComponents([
                    Component(string: symbol.symbol, type: .symbol),
                    Component(string: ":", type: .stat)
                ], at: componentIndex)
            }
            break
        case .stats:
            let stat = visibleStats[indexPath.row]
            
            if let componentIndex = equation.componentIndex(at: cursor) {
                equation.removeComponent(at: componentIndex)
                equation.insertComponents([
                    Component(string: ":\(stat.rawValue)", type: .symbol)
                ], at: componentIndex)
            }
            break
        case .details:
            if indexPath.section == 1 {
                let vc = UIViewController()
                vc.view.backgroundColor = UIColor(hex: "1D1D1E")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        equationView.updateSyntax(for: equation.components)
        textViewDidChange(textView)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 3 && mode == .details {
            return 24
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if mode == .details && indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if mode == .details && indexPath.section == 1 {
            return .insert
        }
        return .none
    }
    
    
}

extension EquationViewController: OperationsAccessoryDelegate {
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
        
        var str:String
        str = "\(operation.textRepresentable)"
//        if text.count > 0, let char = text.char(at: cursor-1) {
//            let charStr = String(char)
//            if charStr == " " {
//                str = "\(operation.textRepresentable) "
//            } else {
//                str = " \(operation.textRepresentable) "
//            }
//        } else {
//            str = "\(operation.textRepresentable) "
//        }
        
        textView.insertText(str)
        textViewDidChange(textView)
    }
}

extension EquationViewController: EvaluatorDelegate {
    
    func evaluatorDidStart() {
        print("evaluatorDidStart")
        
        textView?.resignFirstResponder()
        
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
        self.evaluation = result
        self.mode = .details
        self.tableView.reloadData()
        
        
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Easings.Quart.easeOut)
        animator.addAnimations {
            self.evaluationTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func evaluatorDidFail(withError error: Error) {
        print("evaluatorDidFail withError: \(error.localizedDescription)")
        self.evaluation = nil
        self.evaluationView.setError(error)
        
        textView?.becomeFirstResponder()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Easings.Quart.easeOut)
        animator.addAnimations {
            self.evaluationTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func hideEvaluator() {
        evaluationView.hide()
        let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: Easings.Quart.easeInOut)
        animator.addAnimations {
            self.evaluationTopAnchor.constant = -self.evaluationHeight
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
}

extension EquationViewController:EquationDelegate, ItemDetailsEditorDelegate {
    
    func equationDidUpdate(_ components: [Component]) {
        editingChanged = true
        updateEditingState()
    }
    
    func textDidChange(_ property: ItemDetails.Property, _ text: String?) {
        switch property {
        case .name:
            details.name = text
            break
        case .tags:
            details.setTags(fromStr: text)
            break
        }
        
        editingChanged = true
        updateEditingState()
    }
    
    func updateEditingState() {
        self.saveButton.isEnabled = editingChanged
        self.isModalInPresentation = editingChanged
    }
    
    func segmentedControlDidChange(_ selectedIndex: Int) {
        details.watchLevel = ItemWatchLevel(rawValue: selectedIndex) ?? .none
        editingChanged = true
        updateEditingState()
    }
    
}

extension EquationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("didAttempt!")
        if equation.components.isEmpty {
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { _ in
                self.handleSave()
            }))
            alert.addAction(UIAlertAction(title: "Close anyway", style: .destructive, handler: { _ in
                self.handleCancel()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
