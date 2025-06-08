//lib/widgets/questionnaire_widget.dart
import 'package:flutter/material.dart';

class QuestionnaireWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAnswersUpdated;
  final List<Question> questions;

  const QuestionnaireWidget({
    super.key,
    required this.onAnswersUpdated,
    this.questions = defaultQuestions,
  });

  static const defaultQuestions = [
    Question(
      id: 'symptom',
      title: '症状描述',
      type: QuestionType.text,
      isRequired: true,
      options: [],
      hintText: '请详细描述您的不适症状（如疼痛部位、持续时间等）',
    ),
    Question(
      id: 'history',
      title: '既往病史',
      type: QuestionType.multipleChoice,
      options: ['高血压', '糖尿病', '心脏病', '过敏史'],
    ),
  ];

  bool validateForm() => _QuestionnaireWidgetState.formKey.currentState?.validate() ?? false;

  @override
  State<QuestionnaireWidget> createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  static final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.questions.map(_buildQuestion).expand((e) => [e, const SizedBox(height: 20)]),
          _buildValidationHint(),
        ],
      ),
    );
  }

  Widget _buildQuestion(Question question) => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${question.title}${question.isRequired ? "*" : ""}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (question.hintText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                question.hintText!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          const SizedBox(height: 12),
          _buildAnswerField(question),
        ],
      ),
    ),
  );

  Widget _buildAnswerField(Question question) {
    switch (question.type) {
      case QuestionType.text:
        return TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: question.hintText,
          ),
          maxLines: 3,
          validator: (value) => question.isRequired && (value?.isEmpty ?? true)
              ? '此项为必填内容'
              : null,
          onChanged: (value) => _updateAnswer(question.id, value),
        );
      case QuestionType.singleChoice:
        return FormField<String>(
          validator: (value) => question.isRequired && value == null
              ? '请选择至少一个选项'
              : null,
          builder: (field) => Column(
            children: [
              ...question.options.map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _answers[question.id],
                onChanged: (value) {
                  field.didChange(value);
                  _updateAnswer(question.id, value);
                },
              )),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
            ],
          ),
        );
      case QuestionType.multipleChoice:
        return Column(
          children: question.options.map((option) => CheckboxListTile(
            title: Text(option),
            value: (_answers[question.id] as List?)?.contains(option) ?? false,
            onChanged: (checked) {
              final selected = List.from(_answers[question.id] ?? []);
              checked == true ? selected.add(option) : selected.remove(option);
              _updateAnswer(question.id, selected);
            },
          )).toList(),
        );
    }
  }

  Widget _buildValidationHint() => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
      '* 标记的为必填问题',
      style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontStyle: FontStyle.italic),
    ),
  );

  void _updateAnswer(String questionId, dynamic value) {
    setState(() {
      _answers[questionId] = value;
      widget.onAnswersUpdated(Map.from(_answers));
    });
  }
}

enum QuestionType { text, singleChoice, multipleChoice }

class Question {
  final String id;
  final String title;
  final QuestionType type;
  final List<String> options;
  final bool isRequired;
  final String? hintText;

  const Question({
    required this.id,
    required this.title,
    this.type = QuestionType.text,
    this.options = const [],
    this.isRequired = false,
    this.hintText,
  });
}