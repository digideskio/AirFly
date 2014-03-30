package socketConnection.server
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import socketConnection.CustomBytes;
	import socketConnection.server.std.Client;
	import socketConnection.server.std.Room;

	public class DataHandler
	{
		
		public function DataHandler()
		{
		}
		public static function hand(socket:Socket,data:CustomBytes):void{
			var type:int=data.readInt();
			switch(type)
			{
				case ServerMsgDefine.GET_ROOM_LIST: //客户端请求房间列表
					doReturnRoomList(socket);
					break;
				case ServerMsgDefine.CREATE_ROOM://客户端请求创建服务器
					doCreateRoom(socket,data);
					break;
			}
		}
		
		private static function doReturnCreateRoomResult(socket:Socket,room:Room):void//返回创建房间的结果
		{
			var byte:CustomBytes=new CustomBytes();
			byte.writeInt(ServerMsgDefine.CREATE_ROOM_RESULT);
			byte.writeCustomString(room.roomName);
			byte.writeInt(room.index);
			
			var sendByte:CustomBytes=new CustomBytes();
			sendByte.writeInt(byte.length);
			sendByte.writeBytes(byte);
			socket.writeBytes(sendByte);
			socket.flush();

		}
		
		private static function doCreateRoom(socket:Socket,data:CustomBytes):void
		{
			var room:Room=new Room();
			var client:Client=RemoteData.clientList[socket] as Client;
			client.isRoomMaster=true;
			client.room=room;
			room.master=client;
			room.index=RemoteData.get_room_id();
			room.roomName=data.readCustomString();
			RemoteData.roomList[room.index]=room;
			for(var cs:Socket in RemoteData.clientList)
			{
				doReturnRoomList(cs);
			}
			doReturnCreateRoomResult(socket,room);
		}
		
		private static function doReturnRoomList(socket:Socket):void  //把房间列表推送到客户端
		{
			var tatle:int=0;
			var byte:CustomBytes=new CustomBytes();
			
			for( var index:int in RemoteData.roomList){
				var room:Room=RemoteData.roomList[index];
				var roomIndex:int=index;
				byte.writeInt(roomIndex);//房间索引
				byte.writeCustomString(room.roomName);//房间名
				tatle++;
			}
			var b2:ByteArray=new ByteArray();
			b2.writeInt(ServerMsgDefine.GET_ROOM_LIST);//消息类型
			b2.writeInt(tatle);
			b2.writeBytes(byte);
			
			var sendData:CustomBytes=new CustomBytes();
			sendData.writeInt(b2.length);//
			sendData.writeBytes(b2);
			sendData.compress();
			
			socket.writeBytes(sendData);
			socket.flush();
			
		}
	}
}