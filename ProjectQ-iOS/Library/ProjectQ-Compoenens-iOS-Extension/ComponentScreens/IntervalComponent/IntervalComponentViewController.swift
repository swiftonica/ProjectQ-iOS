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
        
    }

    private let formVC = FormViewController(style: .insetGrouped)
    private let weekSwitchRow = SwitchRow("use.weeks") { $0.title = "Use weeks" }
    private let intervalSwitchRow = SwitchRow("interval.section") { $0.title = "User interval" }
    
    private var intervalValue: Int = 0
    private var weekDays: [IntervalComponentHandlerInput.WeekDay] = []
    private var intervalType: IntervalComponentHandlerInput.IntervalType = .interval(0)

    private var taskTime = Date()
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
                
                self.intervalType = .byWeek(self.weekDays)
            }
        }

        intervalSwitchRow.onChange {
            _ in
            if (self.intervalSwitchRow.value ?? false), (self.weekSwitchRow.value ?? false) {
                self.weekSwitchRow.value = false
                self.weekSwitchRow.cell.switchControl.isOn = false
                
                self.intervalType = .interval(self.intervalValue)
            }
        }
    }

    func setupForm() {
        let weekSection = Section()
        
        formVC.form +++ Section()
            <<< TimeInlineRow() {
                $0.title = "Time of task"
            }
            .onChange {
                guard let _value = $0.value else { return }
                self.taskTime = _value
            }
    
        formVC.form +++ Section()
            <<< intervalSwitchRow
            <<< PhoneRow() {
                $0.title = "Enter interval"
                $0.hidden = Condition.function(["interval.section"]) { form in
                    guard let row = form.rowBy(tag: "interval.section") as? SwitchRow else {
                        return false
                    }
                    return !(row.value ?? false)
                }
            }

        formVC.form +++ weekSection
            <<< weekSwitchRow
            
        let week = IntervalComponentHandlerInput.WeekDay.allCases
        
        for i in 0 ..< week.count  {
            weekSection
                <<< CheckRow() { cell in
                    cell.hidden = Condition.function(["use.weeks"]) { form in
                        guard let row = form.rowBy(tag: "use.weeks") as? SwitchRow else {
                            return false
                        }
                        return !(row.value ?? false)
                    }
                    cell.title = week[i].name
                }
                .onChange { cell in
                    if cell.value ?? false {
                        self.weekDays.append(week[i])
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
}
