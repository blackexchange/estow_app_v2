class Scale {
  Scale({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  static List<Scale> scaleList = <Scale>[
    Scale(
      imagePath: 'assets/design_course/interFace1.png',
      title: 'Enfermeiros',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace2.png',
      title: 'Emergência',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace1.png',
      title: 'Plantonistas',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace2.png',
      title: 'Portaria',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Scale> popularCourseList = <Scale>[
    Scale(
      imagePath: 'assets/design_course/interFace3.png',
      title: 'DNA',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Cardio Pulmonar',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace3.png',
      title: 'App Design Course',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Scale(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}
