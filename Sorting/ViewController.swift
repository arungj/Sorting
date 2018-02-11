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
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // arrayToSort = [1, 2, 3, 4, 5]
        arrayToSort = randomElements()
       // insertion()
        // bubble(array: arrayToSort)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    @IBAction func insertion() {
        // insertionSort(array: arrayToSort)
       // testInsertion2(array: &arrayToSort)
        insertion3(array: &arrayToSort)
        displayLog(text: "Insertion Sort:\n" + arrayToSort.description)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func quick() {
        //        quickSort(array: arrayToSort)
        // var a = [17, 91, 44, 74, 9, 42, 16, 73, 99, 89]
       // quickSort2(array: &arrayToSort, start: 0, end: arrayToSort.count - 1)
        quick3(array: &arrayToSort, start: 0, end: arrayToSort.count - 1)
        displayLog(text: "Quick Sort:\n" + arrayToSort.description)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func merge() {
        // mergeSort(array: &arrayToSort)
        //testMerge(array: &arrayToSort)
        mergeSort3(array: &arrayToSort)
        displayLog(text: "Merge Sort:\n" + arrayToSort.description)
        validateSorted(array: arrayToSort)
    }
    
    @IBAction func binarySearch() {
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
                let elementIndex = self.binarySearch(array: self.arrayToSort, element: element)
                self.displayLog(text: "element found at Index: \(elementIndex)")
            }
            controller.addAction(buttonAction)
        }
        present(controller, animated: true)
    }
    
    @IBAction func generateArray(_ sender: Any) {
        arrayToSort = randomElements()
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
    
    func testInsertion1(a: inout [Int]) {
        for i in 1..<a.count {
            var j = i
            while j > 0 && a[j-1] > a[j] {
                a.swapAt(j, j-1)
                j -= 1
            }
        }
    }
    
    func testInsertion2(array: inout [Int]) {
        for i in 1..<array.count {
            var j = i
            while j > 0 && array[j] < array[j - 1] {
                array.swapAt(j, j - 1)
                j -= 1
            }
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
        if array.count < 2 { return }   // break out from recursion.
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
    func quickSort(array: [Int]) {
        var arrayToSort = array
        
        quickSort(array: &arrayToSort, start: 0, end: arrayToSort.count - 1)
        displayLog(text: "Quick Sort: \n" + arrayToSort.description)
    }
    
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
        displayLog(text: "\n" + "New array\n" + array.description)
        
        return array
    }
    
    func validateSorted(array: [Int]) {
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
        textView.text = textView.text + "\n" + text
        textView.scrollToBottom()
    }
}

extension ViewController {
    // MARK: test quick 1
    func testQuickSort(array: inout [Int]) {
        testQsort(array: &array, start: 0, end: array.count-1)
    }
    
    func testQsort(array: inout [Int], start: Int, end: Int) {
        if start >= end { return }
        let p = partition(array: &array, min: start, max: end)
        testQsort(array: &array, start: 0, end: p - 1)
        testQsort(array: &array, start: p+1, end: end)
    }
    
    func partition(array: inout [Int], min: Int, max: Int) -> Int {
        let pivot = array[max]
        var pIndex = min
        var i = min
        while i < max {
            if array[i] < pivot {
                array.swapAt(pIndex, i)
                pIndex += 1
            }
            i += 1
        }
        array.swapAt(max, pIndex)
        return pIndex
    }
    
    // MARK: test merge1
    func testMerge(array: inout [Int]) {
        if array.count < 2 { return }
        var left = Array(array[0..<array.count / 2])
        var right = Array(array[array.count / 2..<array.count])
        testMerge(array: &left)
        testMerge(array: &right)
        combine(left: &left, right: &right, array: &array)
    }
    
    func combine(left: inout [Int], right: inout [Int], array: inout [Int]) {
        var i = 0, j = 0, k = 0
        while i < left.count && j < right.count {
            if left[i] < right[j] {
                array[k] = left[i]
                i = i+1
            } else {
                array[k] = right[j]
                j = j+1
            }
            k = k+1
        }
        while i < left.count {
            array[k] = left[i]
            k = k+1
            i = i+1
        }
        while j < right.count {
            array[k] = right[j]
            k = k+1
            j = j+1
        }
    }
    
    // MARK: - Test quick2
    func quickSort2(array: inout [Int], start: Int, end: Int) {
        if start >= end { return }
        let pIndex = partition(array: &array, start: start, end: end)
        quickSort2(array: &array, start: 0, end: pIndex - 1)
        quickSort2(array: &array, start: pIndex + 1, end: end)
    }
    
    func partition(array: inout [Int], start: Int, end: Int) -> Int {
        var pIndex = start
        let pivot = array[end]
        for i in start..<end {
            if array[i] <= pivot {
                array.swapAt(i, pIndex)
                pIndex += 1
            }
        }
        array.swapAt(pIndex, end)
        return pIndex
    }
}

extension ViewController {
    func insertion3(array: inout [Int]) {
        for i in 0..<array.count - 1 {
            var j = i + 1
            while j > 0 && array[j - 1] > array[j] {
                array.swapAt(j, j - 1)
                j -= 1
            }
        }
    }
    
    func quick3(array: inout [Int], start: Int, end: Int) {
        if start >= end { return }
        let pIndex = partition3(array: &array, start: start, end: end)
        quick3(array: &array, start: start, end: pIndex - 1)
        quick3(array: &array, start: pIndex + 1, end: end)
    }
    
    func partition3(array: inout [Int], start: Int, end: Int) -> Int {
        let pivot = array[end]
        var pIndex = start
        for i in start..<end {
            if array[i] < pivot {
                array.swapAt(pIndex, i)
                pIndex += 1
            }
        }
        array.swapAt(pIndex, end)
        return pIndex
    }
    
    func mergeSort3(array: inout [Int]) {
        if array.count < 2 { return }
        
        let mid = array.count / 2
        var leftSubArray = Array(array[0..<mid])
        var rightSubArray = Array(array[mid..<array.count])
        mergeSort3(array: &leftSubArray)
        mergeSort3(array: &rightSubArray)
        mergeArrays3(array: &array, leftArray: leftSubArray, rightArray: rightSubArray)
    }
    
    func mergeArrays3(array: inout [Int], leftArray: [Int], rightArray: [Int]) {
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
}

extension UIScrollView {
    func scrollToBottom() {
        let contentHeight = contentSize.height - frame.size.height
        let contentoffsetY = contentHeight > 0 ? contentHeight : 0
        setContentOffset(CGPoint(x: 0, y: contentoffsetY), animated: true)
    }
}
