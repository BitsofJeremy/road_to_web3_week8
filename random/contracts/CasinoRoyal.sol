//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract CasinoRoyal {
  // A game to guess a number.
  // Player A Starts, Player B guesses the number
  // Winner takes all

  // Enums
  enum GameState{
    Started,
    PlayerAFinished,
    PlayerBFinished,
    Reveal,
    Finish
  }

  // Let everyone know the state of the game
   GameState public gameState;

  // Structs
  struct GameSession{
    address playerA;
    uint256 playerAhash;
    address playerB;
    uint256 playerBhash;
    address winner;
    uint256 value;
  }

  GameSession internal gameSession;


  // Events
  event GameStarted (
    GameState state,
    uint value
  );

  event GameStateChange (
    GameState state
  );

  event GameStopped (
    address winner,
    address loser,
    uint value
  );

  // Helper Functions

  // Take a number and encode[hash] it
  function encodeIt(uint256 _number) internal returns (uint256){
    return uint256(keccak256(abi.encodePacked(_number)));
  }

  constructor() {
    gameState = GameState.Started;

    emit GameStarted(gameState, 0);
    emit GameStateChange(gameState);
  }

  function playerAstart(uint _number) payable public {
    // Game is started
    require(gameState == GameState.Started, "It is not your turn.");
    // msg.value is greater than 0
    require(msg.value > 0, "You need to bet to have skin in the game.");
    // Set Player A address
    gameSession.playerA = msg.sender;
    // hash playerA's number is hashed
    gameSession.playerAhash = encodeIt(_number);
    // write bet value
    gameSession.value = msg.value;
    // Set game state to
    gameState = GameState.PlayerAFinished;
    emit GameStateChange(gameState);
  }

  function playerBstart(uint _guess) payable public {
    // Player B's turn
    require(gameState == GameState.PlayerAFinished, "It is not your turn.");
    // msg.value is greater than 0
    require(msg.value > 0, "You need to bet to have skin in the game.");
    // value needs to be the same as player A
    // require(msg.value == gameSession.value,
    //   "Need to bet the same amount as Player A");
    // Set Player B address
    gameSession.playerB = msg.sender;
    // hash playerA's guess
    gameSession.playerBhash = encodeIt(_guess);
    // Set game state to
    gameState = GameState.PlayerBFinished;
    emit GameStateChange(gameState);
  }

  function reveal() public {
    // Reveal State
    require(gameState == GameState.PlayerBFinished, "Both players have not guessed yet.");
    // Setup some address and value
    address payable _playerA = payable(gameSession.playerA);
    address payable _playerB = payable(gameSession.playerB);
    uint _value = gameSession.value;
    // Figure out the winner
    uint _playerAhash = gameSession.playerAhash;
    uint _playerBhash = gameSession.playerBhash;
    uint _winner = _playerAhash ^ _playerBhash;

    // Pay and emit an event
    if (_winner % 2 == 0) {
      // playerA wins
      _playerA.transfer(2*_value);
      emit GameStopped( _playerA, _playerB, _value);
    } else {
      // playerB wins
      _playerB.transfer(2*_value);
      emit GameStopped(_playerB, _playerA, _value);
    }

    // Set state to Finished
    gameState = GameState.Reveal;
    emit GameStateChange(gameState);
  }

  function reset() public {
    // Reset the game
    require(gameState == GameState.Reveal, "Game is still playing.");
    gameState = GameState.Started;

    emit GameStarted(gameState, 0);
    emit GameStateChange(gameState);
  }

}
