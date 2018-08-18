import UIKit

class PickerViewWrapper: NSObject {
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    let items: [PickerItem]
    private(set) var currentlySelectedItem: PickerItem
    
    var onSelectionChanged: ((PickerViewWrapper) -> Void)?
    
    // MARK: - Init

    init(_ items: [PickerItem], currentlySelectedIndex: Int = 0) {
        self.items = items
        let index = currentlySelectedIndex < items.count ? currentlySelectedIndex : 0
        currentlySelectedItem = items[index]
        super.init()
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    // MARK: - Population
    
    // TODO: Make this more generic to support multiple kinds of items in picker
    private func populate(_ view: CountryCodePickerItemView, with item: PickerItem) {
        switch item {
            case .countryCode(let userLocale):
                view.nameLabel.text = userLocale.name
                view.codeLabel.text = userLocale.phoneNumberCode
        }
    }
}

// MARK: - UIPickerViewDataSource

extension PickerViewWrapper: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let currentItem = items[row]
        
        // TODO: Make this more generic to support multiple kinds of items in picker
        let updatedView: CountryCodePickerItemView
        if let view = view as? CountryCodePickerItemView {
            updatedView = view
        } else {
            updatedView = CountryCodePickerItemView()
        }
        populate(updatedView, with: currentItem)
        return updatedView
    }
}

// MARK: - UIPickerViewDelegate

extension PickerViewWrapper: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedItem = items[row]
        onSelectionChanged?(self)
    }
}
