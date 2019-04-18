//
//  ViewController.swift
//  Appreciation
//
//  Created by Iman Zarrabian on 12/04/2019.
//  Copyright © 2019 Askia SaS. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
    var noteValues = [Double]()
    var variableLabels = ["Q1.Opening hours",
                          "Q2.Accessibility",
                          "Q3.Clarity of voice",
                          "Q4.Waiting time before being assisted",
                          "Q5.Quality of the telephone line",
                          "Q9.Welcome by the salesperson",
                          "Q10.Attentiveness of the salesperson",
                          "Q11.Quality of information",
                          "Q12.Courtesy",
                          "Q13.Professionalism",
                          "Q14Clarity of information",
                          "Q15.City ticket office's design and comfort",
                          "Q34.The choice of media used",
                          "Q35.Product relevance"]
    let model = GlobalNote()
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var predictionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var underlyingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //customizeUI()
        createInitialNoteValues()
        updatePrediction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func customizeUI() {
        underlyingView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        underlyingView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: underlyingView.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: underlyingView.widthAnchor),
            ])

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(predictionView)
        blurView.contentView.addSubview(vibrancyView)

        NSLayoutConstraint.activate([
            vibrancyView.heightAnchor.constraint(equalTo: blurView.contentView.heightAnchor),
            vibrancyView.widthAnchor.constraint(equalTo: blurView.contentView.widthAnchor),
            vibrancyView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            vibrancyView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
            ])

        NSLayoutConstraint.activate([
            predictionView.centerXAnchor.constraint(equalTo: vibrancyView.contentView.centerXAnchor),
            predictionView.centerYAnchor.constraint(equalTo: vibrancyView.contentView.centerYAnchor)
            ])
    }

    private func createInitialNoteValues() {
        for _ in 1...14 {
            noteValues.append(5)
        }
    }

    fileprivate func updatePrediction() {

        guard let mlMultiArray = try? MLMultiArray(shape: [1,14], dataType: .double)  else {
            fatalError("Couldn't intialize multi dimensional array")
        }
        for (i,v) in noteValues.enumerated() {
            mlMultiArray[i] = NSNumber(value: v)
        }
        let input = GlobalNoteInput(Notes: mlMultiArray)
        guard let globalNote = try? model.prediction(input: input) else {
            fatalError("Unexpected runtime error.")
        }
        predictionLabel.text = String(format: "%.1f", globalNote.GlobalNote)
    }
}

extension ViewController: QuestionTableViewCellDelegate {
    func cellDidSetNote(cell: QuestionTableViewCell, note: Double) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("Cell not found")
            return
        }
        noteValues[indexPath.row] = note
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updatePrediction()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        cell.delegate = self
        cell.questionName.text = variableLabels[indexPath.row]
        cell.valueLabel.text = String(format: "%.1f", noteValues[indexPath.row])
        cell.noteSlider.value = Float(noteValues[indexPath.row])
        return cell
    }
}
