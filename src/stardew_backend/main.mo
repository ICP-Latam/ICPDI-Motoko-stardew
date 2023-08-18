
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Bool "mo:base/Bool";

actor {
  type Player = {
    id:Nat; 
    name:Text; 
    streams:Nat;
    streams_payed:Nat;
    icp_identity:Principal};


  var secretword = "";
  var player_id = 0;
  var buffer_players =  Buffer.Buffer<Player>(0);  

  public shared(msg) func setword(_word:Text): async Text{
    secretword := _word;
    return secretword;
  };

  public shared (msg) func add_player(_name : Text): async (){
    let newplayer = Buffer.Buffer<Player>(0);
    player_id += 1;
    newplayer.add({
      id = player_id;
      name = _name;
      streams = 0;
      streams_payed = 0;
      icp_identity = msg.caller;
    });
  buffer_players.append(newplayer);
  };

  public shared (msg) func add_streamtoplayer(_name : Text, _input_secretword: Text): async Bool{
    var response = false;
    if (_input_secretword == secretword){
      let newplayer = Buffer.Buffer<Player>(0);
      var buffercount = 0;
      
      Buffer.iterate<Player>(buffer_players, func (_player) {   
        
        if (_player.name == _name){
          buffer_players.add({
            id = _player.id;
            name = _player.name;
            streams = _player.streams +1;
            streams_payed = _player.streams_payed;
            icp_identity = _player.icp_identity;
          });
          let temp = buffer_players.remove(buffercount);
          response := true;
        };
        buffercount += 1;             
      });
    };
    return response;
  };

  public query func getPlayers(): async [Player] {
    return Buffer.toArray(buffer_players);
  };

  public func deleteplayer_byid(idx: Nat) : async Bool  {
    var deleted = false;
    var counterbuffer = 0;
    
    Buffer.iterate<Player>(buffer_players, func (x) {   
      if (x.id == idx){
        deleted := true;
        let deleteplayer = buffer_players.remove(counterbuffer);       
      };
      counterbuffer += 1;
    });

    return deleted
  };

};