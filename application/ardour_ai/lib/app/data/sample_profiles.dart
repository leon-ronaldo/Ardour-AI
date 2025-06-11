class SampleProfile {
  final String profilePic;
  final String name;
  final String? note;
  final String handleName;
  final String following;
  final String followers;

  SampleProfile({
    required this.profilePic,
    required this.name,
    this.note,
    required this.handleName,
    required this.following,
    required this.followers,
  });
}

List<SampleProfile> sampleProfiles = [
  SampleProfile(
    profilePic: "assets/images/sample/ronaldo.jpeg",
    name: "Leon Ronaldo",
    note: "Dreamer, coder, and storyteller on a coastal mission 🌊💭",
    handleName: "@leon.codes",
    following: "512",
    followers: "1.2K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/manish.png",
    name: "Manish Prasad",
    note: "Strategist with a spark — calm face, sharp mind ⚡🧠",
    handleName: "@manish.brainwave",
    following: "318",
    followers: "980",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/soorya.jpeg",
    name: "Sooryodhaya",
    note: "Balancing love and logic — part romantic, part engineer 💘💻",
    handleName: "@soorya.mix",
    following: "602",
    followers: "1.5K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/john.jpg",
    name: "John Wick",
    note: "You took his peace... now face his precision. 🎯🕯️",
    handleName: "@baba.yaga",
    following: "12",
    followers: "10K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/affleck.jpg",
    name: "Ben Affleck",
    note: "Billionaire by day, bat by night 🦇💼",
    handleName: "@gothams.richest",
    following: "47",
    followers: "8.7K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/lucia.png",
    name: "Lucia Caminos",
    note: "Vice City's next legend — fierce, fast, unforgettable 💄🔥",
    handleName: "@lucia.legend",
    following: "701",
    followers: "6.3K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/ashlyn.png",
    name: "Ashlyn Mary",
    note: "Sun-chaser, sister-goals, living the moment 🌞👭",
    handleName: "@ashlyn.daily",
    following: "1.2K",
    followers: "2.8K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/gta-v-michael.jpg",
    name: "Michael De Santa",
    note: "Retired but never rusty — Los Santos’ most chaotic dad 🔫🏡",
    handleName: "@mike.ls",
    following: "38",
    followers: "3.4K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/sam.jpg",
    name: "Samantha Gallen",
    note: "Haunted by memories, holding on to what once was ❄️🌌",
    handleName: "@sam.frost",
    following: "89",
    followers: "1.1K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/vaas.jpg",
    name: "Vaas Montenegro",
    note: "Insanity is doing the same thing and expecting likes 🔁💣",
    handleName: "@vaas.loop",
    following: "5",
    followers: "15K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/edward-kenway.jpg",
    name: "Edward Kenway",
    note: "Freedom sails with me — no chains, only tides 🏴‍☠️⚓",
    handleName: "@captain.kenway",
    following: "104",
    followers: "7.9K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/faithSeed.jpg",
    name: "Faith Seed",
    note: "Bliss isn’t a dream anymore… it’s your new reality 🌸🧬",
    handleName: "@faith.bliss",
    following: "666",
    followers: "6.6K",
  ),
  SampleProfile(
    profilePic: "assets/images/sample/ac2-ezio.jpg",
    name: "Ezio Auditore",
    note: "Legacy written in blood and rooftops — Firenze’s finest 🗡️🏛️",
    handleName: "@ezio.firenze",
    following: "77",
    followers: "12.2K",
  ),
];
