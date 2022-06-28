/*class Urban{

  Urban() {

    //int columns = (int)width/w;
    //int rows = (int)height/w;
    //columns = width/w;
    //rows = height/w;

    initStartPoint();
  }
  
  void initStartPoint() {
    int randomStartUrbanIndexX = int(random(columns));
    int randomStartUrbanIndexY = int(random(rows));
    board[randomStartUrbanIndexX][randomStartUrbanIndexY] = 1;
  }
  
  void generate() {
    
    int[][] next = new int[columns][rows];
    
    for (int x = 1; x < columns - 1; x++) {
      for (int y = 1; y < rows - 1; y++) {
        if (board[x][y] == 1) {
          board[x-1+int(random(3))][y-1+int(random(3))] = 1;
        }
        next[x][y] = board[x][y];
      }
    }
    //mousePressed();
   }
   
  
   
   //human intervention
   /*void mousePressed() {
        int Xcor = (int) mouseX/w;
        int Ycor = (int) mouseY/w;
        fill (255, 153, 255);
        rect(Xcor*w, Ycor*w, w, w);
        
}
  
  void display() {
      for (int i = 0; i < columns;i++) {
        for (int j = 0; j < rows; j++) {
          
          if (board[i][j] == 1) {
            fill(#ffe6ff);
            rect(i*w, j*w, w, w);
          }
        }
      }
  }

}
*/
