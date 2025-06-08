class SampleProfile {
  final String profilePic;
  final String name;
  final String? note;

  SampleProfile({required this.profilePic, required this.name, this.note});
}

List<SampleProfile> sampleProfiles = [
  SampleProfile(
    profilePic: "assets/images/sample/ronaldo.jpeg",
    name: "Leon Ronaldo",
    note: "Dreamer, coder, and storyteller on a coastal mission 🌊💭",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/manish.png",
    name: "Manish Prasad",
    note: "Strategist with a spark — calm face, sharp mind ⚡🧠",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/soorya.jpeg",
    name: "Sooryodhaya",
    note: "Balancing love and logic — part romantic, part engineer 💘💻",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/john.jpg",
    name: "John Wick",
    note: "You took his peace... now face his precision. 🎯🕯️",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/affleck.jpg",
    name: "Ben Affleck",
    note: "Billionaire by day, bat by night 🦇💼",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/lucia.png",
    name: "Lucia Caminos",
    note: "Vice City’s next legend — fierce, fast, unforgettable 💄🔥",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/ashlyn.png",
    name: "Ashlyn Mary",
    note: "Sun-chaser, sister-goals, living the moment 🌞👭",
  ),
];
