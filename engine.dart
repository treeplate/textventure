import 'dart:io';

const String jump = 'jump';
const String quit = 'quit';
const String north = 'n';
const String south = 's';
const String west = 'w';
const String east = 'e';
const String commands = 'commands';
const String pet_cat = 'pet cat';
const String sleep = 'sleep';

Room bedroom = new Room('Bedroom', 'This is a bedroom.');
List<Thing> notTaking = <Thing>[];
bool finished = false;
Room position = bedroom;
final List<Thing> inventory = <Thing>[];
List<Room> rooms = <Room>[];
bool TOS = false;
String roomone;
class Room {
  String name;
  String description;
  String jump;
  Room _e;
  Room _w;
  Room _s;
  Room _n;
  Room down;
  Room up;
  Room(String iname,String idescription,{String ijump : 'boiing'}){
    name = iname;
    description=idescription;
    jump = ijump;
    _n = this;
    _s = this;
    _e = this;
    _w = this;
    down = this;
    up = this;
    rooms.add(this);
  }
  void add(Thing adding) {
    inventory.add(adding);
  }
  void remove(Thing removing) {
    inventory.remove(removing);
  }
  final Set<Thing> inventory = new Set<Thing>();

  Room n()  {
    if (_n == this){
      print('No effect.');
    }
    return _n;
  }

  Room e() {
    if (_e == this){
      print('No effect.');
    }

    return _e;
  }

  Room w() {
    if (_w == this){
      print('No effect.');
    }

    return _w;
  }
  Room s() {
    if (_s == this){
      print('No effect.');
    }

    return _s;
  }
}

class Thing {
  Thing(this.name, Room position){
   position.add(this); 
  }
   final String name;
  void moveTo(Room current, Room movingTo){
    current.remove(this);
    movingTo.add(this);
  }
  bool canMove(){
    return true;
  }
}
class HeavyObject extends Thing{
  HeavyObject(String name, Room position):super(name, position);
  bool canMove(){
    return false;
  }
}

void connect(String dir, Room one, Room two){
  if (dir == 'n'){
    one._n = two;
    two._s = one;
  }
  else if (dir == 's'){
    connect('n', two, one);
  }
  else if (dir == 'w'){
    one._w = two;
    two._e = one;
  }
  else if (dir == 'e'){
    connect('w', two, one);
  }
  else if (dir == 'down'){
    one.down = two;
    two.up = one;
  }
  else if (dir == 'up'){
    connect('down',two, one); 
  }
}

void main() {
  print('Please try out.');
  new Thing('hedral', bedroom);
  new HeavyObject('bed', bedroom);
  new Thing('teddy', bedroom);
  print('Type "commands" for a list of commands.');
  while (!finished) {
    print('debug: Rooms');
    for (Room room in rooms){
      print('\'${room.name}\'');
    }
    print (position.name);
    print (position.description);
    if (position.inventory.isNotEmpty) {
      print('You can see the');
      for (Thing thing in position.inventory){
      print(thing.name);
      }
    }
    if (inventory.isNotEmpty) {
      print('\nYou have the');
      for (Thing thing in inventory){
      print(thing.name);
      }
    }
    print('\nvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
    String command = stdin.readLineSync();
    commanddeal('$command');
  }
}
void commanddeal(String command){
    if (command == jump) {
      print (position.jump);
    } else if (command == north) {
      position = position.n();
    } else if (command == south) {
      position = position.s();
    } else if (command == west) {
      position = position.w();
    } else if (command == east) {
      position = position.e();
    } else if (command == 'down'){
      if (position == position.down){
        print('No Effect');
      }
      position = position.down;
    } else if (command == 'up'){
      if (position == position.up){
        print('No Effect');
      }
      position = position.up;      
    } else if (command == quit) {
      print('Good bye!');
      finished = true;
    } else if (command == commands) {
	print('Commands:\ns = Go south\nn = Go north\ne = Go east\nw = Go west\nquit = Quit this game\njump = Jump\nsleep = Take a nap if there\'s a bed in your current room\ntake (object): Take (object) if you can\ndrop (object): Drop (object) if you can\n\nall where it says (object) does it for all objects that you are able to use for (object)');
    } else if (command == sleep && position == bedroom){
        print('Zzzzz'); 
    } else if (command.startsWith('take all')) {
      print('take all');
      while (position.inventory.isNotEmpty){
        Thing thing = position.inventory.first;
        commanddeal('take ${thing.name}');
        if (TOS == true){
          position.remove(thing);
          notTaking.add(thing);
        }
      }
      while(notTaking.isNotEmpty){
        Thing thing = notTaking.first;
        position.add(thing);
        notTaking.remove(thing);
      }      
    } else if (command.startsWith('drop all')) {
       while (inventory.isNotEmpty){
         Thing thing = inventory.first;
         inventory.remove(thing);
         position.add(thing);
         print('You now don\'t have the ${thing.name}');
       }


    } else if (command.startsWith('take ')) {
      for (Thing thing in position.inventory){
        if (command.substring(5) == thing.name) {
          if (thing.canMove() == true){
            inventory.add(thing);
            position.remove(thing);
            print('You now have the ${thing.name}');
            TOS = false;
            break;
          }else{
            print('The ${thing.name} is too heavy');
            TOS = true; 
          }
        }  
      }
    } else if (command.startsWith('drop ')) {
       for (Thing thing in inventory){
         if (command.substring(5) == thing.name) {
           inventory.remove(thing);
           position.add(thing);
           print('You now don\'t have the ${thing.name}');
           break;
         }
       }
    } else if (command.startsWith('take all')) {
      print('take all');
      while (position.inventory.isNotEmpty){
        Thing thing = position.inventory.first;
        if (thing.canMove() == true){
          inventory.add(thing);
          position.remove(thing);
          print('You now have the ${thing.name}');
        } else {
          print('You can\'t take the ${thing.name}, it\'s too heavy!');
          position.remove(thing);
          notTaking.add(thing);
        } 
      }
      while(notTaking.isNotEmpty){
        Thing thing = notTaking.first;
        position.add(thing);
        notTaking.remove(thing);
      }
    } else if (command.startsWith('make ')) {
      new Thing(command.substring(5), position);
    } else if (command.startsWith('heavymake ')) {
      new HeavyObject(command.substring(10), position);
      
    } else if (command.startsWith('destroy ')) {
      for (Thing thing in position.inventory){
        if (thing.name == command.substring(8)){
          thing.moveTo(position, thingstore);
          break;
        }
      } 
    } else if(command.startsWith('new Room ')) {
      new Room(command.substring(9),'This is a custom room');
    } else if(command == 'connection'){
      String roomer = stdin.readLineSync();    
      for (Room room in rooms){
        if (roomer.startsWith(room.name)){
          roomone = room;
          break;
        }
      }
      for (Room room in rooms){
        if (roomer.substring(roomone.name.length + 1) == (room.name)){
          String dir = stdin.readLineSync();
          connect(stdin.readLineSync(), roomone, room);
          break;
        }
      }

    } else {
      print('Quoi?');
    }
  
}


