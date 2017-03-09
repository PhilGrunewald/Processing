  ////////////////////////////////////////
 // class to read delimited text file  //
////////////////////////////////////////

  class Table {
    String[][] data;           //data of the table

    int numRows,numColumns;    //number of rows and columns

    //CONSTRUCTOR
    Table(String source, String delimeter) {   
      String[] myFile = loadStrings(source); 
      numRows=myFile.length;
      data = new String[numRows][];
      for (int i = 0; i < myFile.length; i++) {
        //jump over empty rows
        if (trim(myFile[i]).length() == 0) {
          continue;
        }   
        data[i] = split(myFile[i],delimeter);
      }       
      //numColumns=data[0].length;
    }

    void saveTableData() {
      String[] myData = new String[numRows];
      for (int i=0;i<numRows;i++){
        String[] thisRow = new String[getNumColumns(i)];
        for (int j=0;j<thisRow.length;j++){
            thisRow[j]=data[i][j];
           }
           myData[i] =join(thisRow," ");
      }

       saveStrings("../connections.txt",myData);
  //graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
    }

    void revertToData() {
    
 // graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
    }

    //METHODS
    //Get number of rows
    int getNumRows() {
      return numRows;
    }

    void addConnection(int row, int connectee) {
      String[] newRow = new String[getNumColumns(row)+1];
      for (int j=0;j<getNumColumns(row);j++){
         newRow[j]=data[row][j];
      }
      newRow[getNumColumns(row)]=str(connectee);
      data[row]= newRow;
    }
    
    //Get number of columns in this row PG 31 May 2013
    int getNumColumns(int row) {
      numColumns=data[row].length;
      return numColumns; 
    } 

    //Get value as a string 
    String getString(int iRow, int iCol) { //<>//
      return data[iRow][iCol];
    }

    int getInt(int iRow, int iCol) {
      return parseInt(data[iRow][iCol]);
    }

    // get total number of connections
    int totalConnections(){
      int Connections=0;
      for (int i=0;i<numRows;i++){
      //     Connections+=t.getNumColumns(i);
        }
      return Connections;
    }
    
    //returns maximum value in a column
    int getMaxCol(int j){
      int vmax=0;
      for(int i=0;i<getNumRows();i++){
        int cval=getInt(i,j);
        vmax=vmax<cval?cval:vmax;
      } 
      return vmax;
    }
    
    int getSumCol(int j){
      int sumCol=0;
      // start at row 1 (row 0 is the header)
      for(int i=1;i<numRows;i++){
        sumCol=sumCol+getInt(i,j);
      } 
      return sumCol;
    }
    
  } //end | tabla class
