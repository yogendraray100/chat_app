String createChatRoom(String userId, String user2Id) {
  List<String> uidList = [userId, user2Id];
  uidList.sort();
  return uidList.toString();
}
