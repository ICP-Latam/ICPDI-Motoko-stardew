
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
    icp_identity:Principal};

  var player_id = 0;
  var buffer_players =  Buffer.Buffer<Player>(0);  

  
  func isplayer_added(msg:Principal): Bool{  
    var playerfound = false;
    Buffer.iterate<Player>(buffer_players, func (x) {   
      if (x.icp_identity == msg){
        playerfound := true};
    });
    return playerfound
  };

  public shared (msg) func add_player(_name : Text): async (){
    let newplayer = Buffer.Buffer<Player>(0);
    player_id += 1;
    newplayer.add({
      id = player_id;
      name = _name;
      icp_identity = msg.caller;
    });
    buffer_players.append(newplayer);
  };

  public query func getPlayers(): async [Player] {
    return Buffer.toArray(buffer_players);
  };

  public func deleteplayer_byid(idx: Nat) : async Bool  {
    var deleted = false;
    var index = 0;
    
    Buffer.iterate<Player>(buffer_players, func (x) {   
      if (x.id == idx){
        deleted := true;
        let deleteplayer = buffer_players.remove(index);       
      };
      index += 1;
    });

    return deleted
  };

};