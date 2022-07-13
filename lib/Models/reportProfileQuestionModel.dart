final questions = {
  "data": [
    {
      "question": "How is this Suspicious, spam, or fake",
      "answer": [
        {
          "ansTitle": "Misinformation",
          "ansSubtitle":
              "Spreading false or misleading information as if it were factual"
        },
        {
          "ansTitle": "Fraud or scam",
          "ansSubtitle":
              "Deceiving others to obtain money or access private information"
        },
        {
          "ansTitle": "Spam",
          "ansSubtitle":
              "Sharing irrelevant or repeated content to boost visibility or for monetary gain"
        },
        {
          "ansTitle": "Fake account",
          "ansSubtitle": "Inaccurate or misleading representation"
        },
        {
          "ansTitle": "Impersonation",
          "ansSubtitle": "Pretending to be someone else"
        },
        {
          "ansTitle": "Hacked account",
          "ansSubtitle": "Unauthorized account takeover"
        }
      ]
    },
    {
      "question": "How is this Harassment or hateful speech",
      "answer": [
        {
          "ansTitle": "Bullying or trolling",
          "ansSubtitle":
              "Attacking or intimidating others, or deliberately and repeatedly disrupting conversations"
        },
        {
          "ansTitle": "Sexual harassment",
          "ansSubtitle":
              "Unwanted romantic advances, requests for sexual favours, or unwelcome sexual remarks"
        },
        {
          "ansTitle": "Hateful or abusive speech",
          "ansSubtitle": " Hateful, degrading, or inflammatory speech"
        },
        {
          "ansTitle": "Spam",
          "ansSubtitle":
              "Sharing irrelevant or repeated content to boost visibility or for monetary gain"
        }
      ]
    },
    {
      "question": "How is this Violence or physical harm",
      "answer": [
        {
          "ansTitle": "Inciting violence or is a threat",
          "ansSubtitle": "Encouraging violent acts or threatening physical harm"
        },
        {
          "ansTitle": "Self-harm",
          "ansSubtitle": "Suicidal remarks or threatening to harm oneself"
        },
        {
          "ansTitle": "Shocking or gory",
          "ansSubtitle": "Shocking or graphic content"
        },
        {
          "ansTitle": "Terrorism or acts of extreme violence",
          "ansSubtitle":
              "Depicting or encouraging terrorist acts or severe harm"
        }
      ]
    },
    {
      "question": "Depicting or encouraging terrorist acts or severe harm",
      "answer": [
        {
          "ansTitle": "Nudity or sexual content",
          "ansSubtitle": "Nudity, sexual scenes or language, or sex trafficking"
        },
        {
          "ansTitle": "Sexual harassment",
          "ansSubtitle":
              "Unwanted romantic advances, requests for sexual favors, or unwelcome sexual remarks"
        },
        {
          "ansTitle": "Shocking or gory",
          "ansSubtitle": "Shocking or graphic content"
        }
      ]
    },
    {
      "question": "Other",
      "answer": [
        {"ansTitle": "", "ansSubtitle": ""},
        {"ansTitle": "", "ansSubtitle": ""},
        {"ansTitle": "", "ansSubtitle": ""},
        {"ansTitle": "", "ansSubtitle": ""},
      ]
    },
  ]
};

class ReportQuestion {
  ReportQuestion({
    required this.data,
  });
  late final List<Data> data;

  ReportQuestion.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.question,
    required this.answer,
  });
  late final String question;
  late final List<Answer> answer;

  Data.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = List.from(json['answer']).map((e) => Answer.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['question'] = question;
    _data['answer'] = answer.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Answer {
  Answer({
    required this.ansTitle,
    required this.ansSubtitle,
  });
  late final String ansTitle;
  late final String ansSubtitle;

  Answer.fromJson(Map<String, dynamic> json) {
    ansTitle = json['ansTitle'];
    ansSubtitle = json['ansSubtitle'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ansTitle'] = ansTitle;
    _data['ansSubtitle'] = ansSubtitle;
    return _data;
  }
}
