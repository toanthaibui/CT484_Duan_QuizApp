import 'package:flutter/material.dart';
import 'package:quiz_app/services/database.dart';

import '../widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";
  bool _isLoading = false;

  DatabaseService databaseService = new DatabaseService();

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };

      await databaseService
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
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
          iconTheme: IconThemeData(color: Colors.black87),
          brightness: Brightness.dark,
        ),
        body: _isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Nhập vào câu hỏi" : null,
                        decoration: InputDecoration(hintText: "Câu hỏi"),
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Nhập vào câu hỏi số 1" : null,
                        decoration: InputDecoration(
                            hintText: "Câu hỏi số 1 (Câu hỏi đúng)"),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Nhập vào câu hỏi số 2" : null,
                        decoration: InputDecoration(hintText: "Câu hỏi số 2"),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Nhập vào câu hỏi số 3" : null,
                        decoration: InputDecoration(hintText: "Câu hỏi số 3"),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Nhập vào câu hỏi số 4" : null,
                        decoration: InputDecoration(hintText: "Câu hỏi số 4"),
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                      Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: blueButton(
                                context: context,
                                label: "Lưu",
                                buttonWidth:
                                    MediaQuery.of(context).size.width / 2 - 36),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              uploadQuestionData();
                            },
                            child: blueButton(
                                context: context,
                                label: "Thêm câu hỏi",
                                buttonWidth:
                                    MediaQuery.of(context).size.width / 2 - 36),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ));
  }
}
