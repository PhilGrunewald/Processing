  ////////////////////////////////////////
 // class to read delimited text file  //
////////////////////////////////////////

  class JSTable {
    String[][] data;           //data of the table

    int numRows,numColumns;    //number of rows and columns

    //CONSTRUCTOR
    JSTable(String source, String delimeter) {   
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
    } 
    //METHODS
    //Get number of rows
    int getNumRows() {
      return numRows;
    }
    
    int getInt(int iRow, int iCol) {
      return parseInt(data[iRow][iCol]);
    }
    
    int getThemeSize(int theme) {
      int sumTheme =0;
      for(int i=1;i<numRows;i++){
        sumTheme=sumTheme+getInt(i,theme); // theme 0 (economics) is first col
      } 
      return sumTheme;
    }
    
    int[] getParticipantThemes(int participant) {
      int[] participantThemes = new int[12];
      for(int i=0;i<12;i++) {
        participantThemes[i] = parseInt(data[participant][i]);        
      }
      return participantThemes;   
    }
    
    int[] getThemeMatch(int theme) {
      int[] matches = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // 11 themes
      for(int p=1;p<numRows;p++){
        if(int(data[p][theme])==1) {
          for(int t=0;t<12;t++) {
          matches[t]=matches[t]+getParticipantThemes(p)[t];
          }
        }
      } 
      return matches;
    }
    
  } //end | tabla class
