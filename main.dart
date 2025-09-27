import 'dart:io';
import 'dart:math';

void main() {
  stdout.write("Enter your player name: ");
  String? playerName = stdin.readLineSync();

  int health = 100;
  int gold = 50;
  List<String> inventory = ["sword"];
  List<String> activeEffects = [];

  while (health > 0) {
    int event = Random().nextInt(3);

    if (event == 0) {
      // Monster
      health = battleMonster(health, activeEffects, gold);
    } else if (event == 1) {
      // Chest
      openChest(inventory);
    } else {
      stdout.writeln("Room is empty");
    }

    // DISPLAY current status
    stdout.writeln("Health: $health, Gold: $gold, Inventory: $inventory");

    // PROMPT player
    stdout.write("Choose: c to continue, u to use item, q to uit: ");
    String? choice = stdin.readLineSync();

    if (choice == "u") {
      health = useItem(inventory, activeEffects, health);
    } else if (choice == "q") {
      stdout.writeln("You leave the dungeon with your loot");
      break;
    } else if (choice == "c") {
      // do nothing, loop continues
    }
  }

  // END GAME
}

// FUNCTION battle_monster()
int battleMonster(int health, List<String> activeEffects, int gold) {
  int monsterHealth = 20 + Random().nextInt(21);

  while (monsterHealth > 0 && health > 0) {
    stdout.write("Choose a to attack or r to run: ");
    String? action = stdin.readLineSync();

    if (action == "a") {
      int damage = 5 + Random().nextInt(11);

      if (activeEffects.contains("amulet")) {
        damage += 5;
        activeEffects.remove("amulet");
      }

      monsterHealth -= damage;

      if (monsterHealth > 0) {
        int monsterDamage = 5 + Random().nextInt(8);

        if (activeEffects.contains("shield")) {
          monsterDamage = monsterDamage ~/ 2; // halve the damage
          activeEffects.remove("shield");
        }

        health -= monsterDamage;
      }
    } else if (action == "r") {
      return health;
    }
  }

  if (health <= 0) {
    stdout.writeln("Game Over");
    exit(0);
  } else {
    int reward = 10 + Random().nextInt(21);
    gold += reward;
    stdout.writeln("Victory! You earned $reward gold.");
  }

  return health;
}

// FUNCTION open_chest()
void openChest(List<String> inventory) {
  List<String> rewards = ["potion", "shield", "amulet"];
  String reward = rewards[Random().nextInt(rewards.length)];
  inventory.add(reward);
  stdout.writeln("You found a $reward");
}

// FUNCTION use_item()
int useItem(List<String> inventory, List<String> activeEffects, int health) {
  if (inventory.isEmpty) {
    stdout.writeln("No items");
    return health;
  }

  stdout.writeln("Inventory: $inventory");
  stdout.write("Choose an item: ");
  String? item = stdin.readLineSync();

  if (item == "potion" && inventory.contains("potion")) {
    health += 20;
    inventory.remove("potion");
  } else if (item == "shield" && inventory.contains("shield")) {
    activeEffects.add("shield");
    inventory.remove("shield");
  } else if (item == "amulet" && inventory.contains("amulet")) {
    activeEffects.add("amulet");
    inventory.remove("amulet");
  }

  return health;
}
