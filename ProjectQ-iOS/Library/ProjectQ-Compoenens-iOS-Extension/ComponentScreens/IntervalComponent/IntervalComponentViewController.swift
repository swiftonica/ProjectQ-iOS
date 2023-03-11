//
//  IntervalComponentViewController.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 02.03.2023.
//

import Foundation
import Eureka
import UIKit
import ProjectQ_Components
import SPAlert

protocol IntervalViewControllerInterfaceContract {
    func setTime(_ time: Date)
    func setIntervalType(_ intervalType: IntervalComponentHandlerInput.IntervalType)
}
 
// no presenter. No separate logic
class IntervalViewController: UIViewController, ViewComponentReturnable {
    var didReturnComponent: ((Component) -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Interval"
        
        addForm()
        setupForm()
        setupFormRowsLogic()
        
        addDoneNavigationButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(_ data: Data) {
        guard let input = try? JSONDecoder().decode(IntervalComponentHandlerInput.self, from: data) else {
            return SPAlert.present(title: "Error", message: "Failed to parse component data", preset: .error)
        }
        self.interfaceContract.setTime(input.time)
        self.interfaceContract.setIntervalType(input.intervalType)
    }

    // stateless
    private let formVC = FormViewController(style: .insetGrouped)

    private let weekSwitchRow = SwitchRow("use.weeks") { $0.title = "Use weeks" }
    private let intervalSwitchRow = SwitchRow("interval.section") { $0.title = "User interval" }
    
    private lazy var timeRow =  TimeInlineRow() {
        $0.title = "Time of task"
    }.onChange {
        guard let _value = $0.value else { return }
        self.taskTime = _value // [!] <- set state
    }
    
    private lazy var intervalValueRow = PhoneRow() {
        $0.title = "Enter interval"
        $0.hidden = Condition.function(["interval.section"]) { form in
            guard let row = form.rowBy(tag: "interval.section") as? SwitchRow else {
                return false
            }
            return !(row.value ?? false)
        }
    }

    private lazy var interfaceContract = self
    
    // state
    private var intervalValue: Int = 0
    private var weekDays: [IntervalComponentHandlerInput.WeekDay] = []
    private var intervalType: IntervalComponentHandlerInput.IntervalType = .interval(0)

    private var taskTime = Date()
}

extension IntervalViewController: IntervalViewControllerInterfaceContract {
    func setIntervalType(_ intervalType: IntervalComponentHandlerInput.IntervalType) {
        switch intervalType {
        case .byWeek(let weekDays):
            self.setWeekDaysInUI(weekDays: weekDays)
            
        case .interval(let interval):
            self.setInterval(interval)
        }
    }
    
    func setTime(_ time: Date) {
        self.timeRow.value = time
    }
}

private extension IntervalViewController {
    @objc private func doneButtonDidTap() {
        let input = IntervalComponentHandlerInput(
            intervalType: self.intervalType,
            time: self.taskTime,
            lastDate: Date()
        )
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(input) else {
            return
        }
        
        didReturnComponent?(
            .interval.inputed(data)
        )
    }
    
    func addDoneNavigationButton() {
        navigationItem.rightBarButtonItem = .init(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonDidTap)
        )
    }
    
    func addForm() {
        addChild(formVC)
        view.addSubview(formVC.view)
        formVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        formVC.didMove(toParent: self)
    }
    
    func setupFormRowsLogic() {
        weekSwitchRow.onChange {
            _ in
            if (self.intervalSwitchRow.value ?? false), (self.weekSwitchRow.value ?? false) {
                self.intervalSwitchRow.value = false
                self.intervalSwitchRow.cell.switchControl.isOn = false
                
                self.intervalType = .byWeek(self.weekDays) // [!] <- set state
            }
        }
        
        intervalSwitchRow.onChange {
            _ in
            if (self.intervalSwitchRow.value ?? false), (self.weekSwitchRow.value ?? false) {
                self.weekSwitchRow.value = false
                self.weekSwitchRow.cell.switchControl.isOn = false
                
                self.intervalType = .interval(self.intervalValue) // [!] <- set state
            }
        }
    }
    
    func setupForm() {
        formVC.form +++ Section()
        <<< self.timeRow
         
        formVC.form +++ Section()
        <<< intervalSwitchRow
        <<< intervalValueRow
        
        addWeeakDaysSection()
    }
    
    func addWeeakDaysSection(_ _weekDays: IntervalComponentHandlerInput.WeekDays = []) {
        let weekSection = Section()
        formVC.form +++ weekSection
        <<< weekSwitchRow
        
        let allWeekDays = IntervalComponentHandlerInput.WeekDay.allCases
        self.weekDays = _weekDays
        
        for i in 0 ..< allWeekDays.count  {
            weekSection
            <<< CheckRow() { cell in
                cell.hidden = Condition.function(["use.weeks"]) { form in
                    guard let row = form.rowBy(tag: "use.weeks") as? SwitchRow else {
                        return false
                    }
                    return !(row.value ?? false)
                }
                
                cell.title = allWeekDays[i].name
                if let _ = _weekDays.first (where: {
                    $0.index == allWeekDays[i].index
                }) {
                    cell.value = true
                } else {
                    cell.value = false
                }
                
            }
            .onChange { cell in
                if cell.value ?? false {
                    self.weekDays.append(allWeekDays[i])
                }
                else {
                    guard
                        let someIndex = self.weekDays.firstIndex(where: { return $0.index == i })
                    else {
                        return
                    }
                    self.weekDays.remove(at: someIndex)
                }
            }
        }
    }
    
    func setWeekDaysInUI(weekDays: IntervalComponentHandlerInput.WeekDays) {
        let weekSectionRowIndex = 3
        self.formVC.form.remove(at: weekSectionRowIndex)
        addWeeakDaysSection(weekDays)
        weekSwitchRow.value = true
        
        self.weekDays = weekDays // [!] <- set state
    }
        
    func setInterval(_ interval: Int) {
        self.intervalValueRow.value = String(interval)
        self.intervalValue = interval // [!] <- set state
    }
}
 
