import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/result.dart';
import 'package:quiz_app/widgets/quiz_play_widgets.dart';

import '../widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String? quizId;
  PlayQuiz(this.quizId);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

Stream? infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();

  QuerySnapshot? questionSnapshot;

  bool isLoading = true;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot["question"];

    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"],
    ];

    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId!).then((value) {
      questionSnapshot = value;
      _notAttempted = questionSnapshot!.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnapshot!.docs.length;

      print("$total this is total");
      setState(() {});
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        print("this is x $x");
        return [_correct, _incorrect];
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: appBar(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black54),
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnapshot!.docs.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnapshot == null ||
                            questionSnapshot!.docs.length == 0
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionSnapshot!.docs.length,
                            itemBuilder: (context, index) {
                              return QuizPlayTitle(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnapshot!.docs[index]),
                                index: index,
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Result(
                      correct: _correct, incorrect: _incorrect, total: total)));
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      InfoQuestion(
                        text: "Tổng",
                        number: widget.length,
                      ),
                      InfoQuestion(
                        text: "Đúng",
                        number: _correct,
                      ),
                      InfoQuestion(
                        text: "Sai",
                        number: _incorrect,
                      ),
                      InfoQuestion(
                        text: "Còn lại",
                        number: _notAttempted,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPlayTitle extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTitle({required this.questionModel, required this.index});

  @override
  State<QuizPlayTitle> createState() => _QuizPlayTitleState();
}

class _QuizPlayTitleState extends State<QuizPlayTitle> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Câu ${widget.index + 1}: ${widget.questionModel.question!}",
          style: TextStyle(fontSize: 17, color: Colors.black87),
        ),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered!) {
              ///correct
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option1!;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option1!;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption!,
            description: widget.questionModel.option1!,
            option: "A",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered!) {
              ///correct
              if (widget.questionModel.option2 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option2!;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                print("${widget.questionModel.correctOption}");
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option2!;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption!,
            description: widget.questionModel.option2!,
            option: "B",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered!) {
              ///correct
              if (widget.questionModel.option3 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option3!;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option3!;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption!,
            description: widget.questionModel.option3!,
            option: "C",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered!) {
              ///correct
              if (widget.questionModel.option4 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option4!;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option4!;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption!,
            description: widget.questionModel.option4!,
            option: "D",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
