//
//  ViewController.swift
//  Sorting
//
//  Created by Arun George on 12/6/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

/** Caveats:
 1: Lower bound and upper bound for i and j.
 2: Exit condition is in the recursive function.
 3: In place sorting.
 */

class ViewController: UIViewController {
    
    var arrayToSort = [Int]()
    var generatedArray = [Int]()
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // arrayToSort = [1, 2, 3, 4, 5]
        generateArray(self)
        // bubble(array: arrayToSort)
    }
    
    // MARK: - Actions
    @IBAction func insertion() {
        arrayToSort = generatedArray
        displayLog(text: "\nInsertion Sort:")
        insertionSort(array: &arrayToSort)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func quick() {
        arrayToSort = generatedArray
        displayLog(text: "\nQuick Sort:")
        quickSort(array: &arrayToSort, start: 0, end: arrayToSort.count - 1)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func merge() {
        arrayToSort = generatedArray
        displayLog(text: "\nMerge Sort:")
        mergeSort(array: &arrayToSort)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func binarySearch() {
        arrayToSort = generatedArray
        displayLog(text: "\nBinary Search:")
        insertionSort(array: &arrayToSort)
        displayLog(text: "Sorted array:\n" + arrayToSort.description)
        let controller = UIAlertController(title: "Enter element", message: nil, preferredStyle: .alert)
        controller.addTextField { field in
            let buttonAction = UIAlertAction(title: "done", style: .default) { alert in
                guard let text = field.text,
                    let element = Int(text) else {
                        self.displayLog(text: "invalid text: " + (field.text ?? ""))
                        return
                }
                self.displayLog(text: "Searching element: \(element)")
                let elementIndex = self.binarySearch(array: self.arrayToSort, element: element)
                let message = elementIndex != -1
                    ? "element found at Index: \(elementIndex)"
                    : "Element not found"
                self.displayLog(text: message)
            }
            controller.addAction(buttonAction)
        }
        present(controller, animated: true)
    }
    
    @IBAction func generateArray(_ sender: Any) {
        generatedArray = randomElements()
    }
    
    // MARK: - Insertion
    func insertionSort(array: inout [Int]) {
        var jRepetition = 0
        print("total elements: \(array.count)")
        for i in 1..<array.count {
            var j = i
            jRepetition = 0
            while j > 0 && array[j-1] > array[j] {
                array.swapAt(j, j-1)
                j -= 1
                jRepetition += 1
            }
            print("jRepetition: \(jRepetition)")
        }
    }
    
    // MARK: - Bubble Sort
    func bubble(array: [Int]) {
        var arrayToSort = array
        print("Before")
        print( arrayToSort)
        var didSwap = false
        var jRepetition = 0
        print("total elements: \(arrayToSort.count)")
        for i in 0..<arrayToSort.count {
            didSwap = false
            jRepetition = 0
            for j in 0..<arrayToSort.count-i-1 {
                jRepetition += 1
                if arrayToSort[j] > arrayToSort[j+1] {
                    arrayToSort.swapAt(j, j+1)
                    didSwap = true
                }
            }
            print("jRepetition: \(jRepetition)")
            if !didSwap { break }
        }
        print("\n After")
        print( arrayToSort)
    }
    
    // MARK: - Merge Sort
    func mergeSort(array: inout [Int]) {
        // Divide the array into partitions and call merge.
        if array.count < 2 { return }   // exit from recursion.
        var leftArray = Array(array[0..<array.count / 2])
        var rightArray = Array(array[array.count / 2..<array.count])
        mergeSort(array: &leftArray)
        mergeSort(array: &rightArray)
        mergeInto(array: &array, leftArray: leftArray, rightArray: rightArray)
    }
    
    func mergeInto(array: inout [Int], leftArray: [Int], rightArray: [Int]) {
        var i = 0, j = 0, k = 0
        while i < leftArray.count && j < rightArray.count {
            if leftArray[i] <= rightArray[j] {
                array[k] = leftArray[i]
                i += 1
            } else {
                array[k] = rightArray[j]
                j += 1
            }
            k += 1
        }
        while i < leftArray.count {
            array[k] = leftArray[i]
            i += 1
            k += 1
        }
        while j < rightArray.count {
            array[k] = rightArray[j]
            j += 1
            k += 1
        }
    }
    
    // MARK: - Quick Sort
    func quickSort( array: inout [Int], start: Int, end: Int) {
        if start < end {
            let p = partition(a: &array, start: start, end: end)
            quickSort(array: &array, start: start, end: p - 1)
            quickSort(array: &array, start: p + 1, end: end)
        }
    }
    
    func partition( a: inout [Int], start: Int, end: Int) -> Int {
        var pIndex = start
        let pivot = a[end]
        for i in start..<end {
            if a[i] <= pivot {
                a.swapAt(i, pIndex)
                pIndex+=1
            }
        }
        a.swapAt(pIndex, end)
        return pIndex
    }
    
    //MARK: - Other Methods
    func binarySearch(array: [Int], element: Int) -> Int {
        var start = 0, end = array.count - 1
        while start <= end {
            let mid = (start + end) / 2
            // Optimizing for large integer overflow in case of very large arrays.
            //let mid = start / 2 + end / 2
            if array[mid] == element {
                return mid
            } else if element < array[mid] {
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        return -1
    }
    
    //MARK: - Other Methods
    func randomElements() -> [Int] {
        var array = [Int]()
        for _ in 1...10 {
            array.append(Int(arc4random_uniform(100)))
        }
        displayLog(text: "\nNew array\n" + array.description)
        return array
    }
    
    func validateSorted(array: [Int]) {
        displayLog(text: array.description)
        for i in 0..<array.count-1 {
            if array[i] > array[i+1] {
                displayLog(text: "invalid sorting")
                return
            }
        }
        displayLog(text: "Correctly sorted array.")
    }
    
    func displayLog(text: String) {
        print(text)
        var textToDisplay = textView.text + "\n" + text
        if textView.text.count == 0 {
            textToDisplay = textToDisplay.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        textView.text = textToDisplay
        textView.scrollToBottom()
    }
}

extension UIScrollView {
    func scrollToBottom() {
        let contentHeight = contentSize.height - frame.size.height
        let contentoffsetY = contentHeight > 0 ? contentHeight : 0
        setContentOffset(CGPoint(x: 0, y: contentoffsetY), animated: true)
    }
}
