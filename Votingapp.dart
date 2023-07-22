import 'dart:async';
import 'dart:io';

void main() {
  List<String> candidates = ['Candidate A', 'Candidate B', 'Candidate C'];

  // Initialize votes for each candidate to 0
  List<int> votes = List<int>.filled(candidates.length, 0);

  print('\n*****WELCOME TO THE VOTING PORTAL*****\n');

  for (int userCount = 1; userCount <= 5; userCount++) {
    print('\nVoter $userCount Enter Your Name:');
    String userName = stdin.readLineSync()!;

    print('Voter  $userCount Enter Your age:');
    int userAge = int.tryParse(stdin.readLineSync()!) ?? 0;

      bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  bool isValidCnic(String cnic) {
    // CNIC should be exactly 13 digits
    if (cnic.length != 13) return false;

    // CNIC should contain only numeric characters
    if (!isNumeric(cnic)) return false;

    return true;
  }

  print("Enter Your CNIC Number (without dashes):");
  String cnic = stdin.readLineSync() ?? "";

    
    if (userAge < 18) {
      print('SORRY, $userName, you must be 18 or above to vote.');
    } else if (hasVoted(userName)) {
      print('SORRY, $userName, you have already voted.');
    } else if(cnic.length != 13 || !isNumeric(cnic)){
      print('SORRY, $userName, your CNIC is not Valid.');
    } 
    else {
      print('\nCANDIDATES:');
      for (int i = 0; i < candidates.length; i++) {
        print('${i + 1}. ${candidates[i]}');
      }

      print('\nENTER YOUR CHOICE(1-${candidates.length}):');
      String input = stdin.readLineSync()!;
      int choice = int.tryParse(input)!;

      if (choice == null || choice < 1 || choice > candidates.length) {
        print('INVALID CHOICE PLEASE ENTER A VALID OPTION');
      } else {
        votes[choice - 1]++;
        print('\nTHANKYOU, $userName, TO VOTE FOR ${candidates[choice - 1]}!');
        saveVoter(userName);
      }
    }
  }

  print('\nVOTING IS CLOSED.RESULT WILL BE SHOWN AFTER 1 MINUTE...');
  startResultDisplayTimer(candidates, votes);
}

void startResultDisplayTimer(List<String> candidates, List<int> votes) {
  Timer(Duration(minutes: 1), () => displayResults(candidates, votes));
}

void displayResults(List<String> candidates, List<int> votes) {
  print('\n-------VOTING RESULTS:-------\n');
  int totalVotes = 0;
  for (int i = 0; i < candidates.length; i++) {
    print('${candidates[i]}: ${votes[i]} votes');
    totalVotes += votes[i];
  }

  int winnerIndex = votes.indexOf(votes.reduce((max, current) => max > current ? max : current));
  print('\n-------WINNER:-------\n\n ${candidates[winnerIndex]}');
  print('\n-------TOTAL VOTES CASTED:--------\n\n $totalVotes\n');
}

// Simple function to check if the user has voted already (using a text file for simplicity)
bool hasVoted(String userName) {
  File file = File('voters.txt');
  if (file.existsSync()) {
    List<String> voters = file.readAsLinesSync();
    return voters.contains(userName);
  }
  return false;
}

// Simple function to save the user's name to the voters list (using a text file for simplicity)
void saveVoter(String userName) {
  File file = File('voters.txt');
  file.writeAsStringSync(userName + '\n', mode: FileMode.append);
}

