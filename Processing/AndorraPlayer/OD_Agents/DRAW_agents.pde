void drawAgents() {
  tableCanvas.beginDraw();
  
  
  // Instead of solid background draws a translucent overlay every frame.
  // Provides the effect of giving animated elements "tails"
  tableCanvas.noStroke();
  //fill(#ffffff, 100);
  tableCanvas.fill(0, 75);
  tableCanvas.rect(0,0,canvasWidth,canvasHeight);
  
  tableCanvas.translate(scrollX, scrollY);
  
  if(showTraces) {
    traces.display();
  }
  
  if (showObstacles) {
    for (Obstacle o : testWall) {
      o.display(#0000FF, 100);
    }
  }
  
  numAgents = 0;
  
  for (Swarm s : testSwarm) {
    s.update();
    numAgents += s.swarm.size();
    
    if (showSource) {
      s.displaySource();
    }
    
    if (showEdges) {
      s.displayEdges();
    }
    
    if (showSwarm) {
      
      if (showTraces) {
        traces.update(s);
        s.display("grayscale");
      } else {
        s.display("color");
      }
    }
    
  }
  
  traces.decay();
  
  for(int i=0; i<testSwarm.length; i++) {
    swarmSize[i] = testSwarm[i].swarm.size();
  }
  
//  if (frameRate < 45) {
//    maxAgents --;
//  } else if (frameRate > 50) {
//    maxAgents ++;
//  }
  
  if (numAgents > maxAgents) {
    int rand;
    int counter;
    while(numAgents > maxAgents) {
      
      // Picks a random agent from one of the swarms.  Larger swarms are more likely to be selected
      rand = int(random(0, numAgents));
      counter = 0;
      for (int i=0; i<testSwarm.length; i++) {
        counter += swarmSize[i];
        if (rand < counter) {
          rand = i;
          //println("random: " + rand);
          break;
        }
      }
      
      //kills a random agent in the selected swarm
      if (testSwarm[rand].swarm.size() > 0) {
        testSwarm[rand].swarm.get(int(random(testSwarm[rand].swarm.size()))).finished = true;
        numAgents--;
      }
    }
    adjust /= 0.99;
  } else {
    adjust *= 0.99;
  }
  //println("Adjust: " + adjust);

  
  tableCanvas.translate(-scrollX, -scrollY);
  
  textSize = 8;
  
  if (showInfo) {
    tableCanvas.pushMatrix();
    tableCanvas.translate(2*textSize, 2*textSize + scroll);
    
    // Background rectangle
    tableCanvas.fill(#555555, 50);
    tableCanvas.noStroke();
    tableCanvas.rect(0, 0, 32*textSize, (testSwarm.length+4)*1.5*textSize, textSize, textSize, textSize, textSize);
    
    // Text
    tableCanvas.translate(2*textSize, 2*textSize);
    for (int i=0; i<testSwarm.length; i++) {
      tableCanvas.fill(testSwarm[i].fill);
      tableCanvas.textSize(textSize);
      tableCanvas.text("Swarm[" + i + "]: ", 0,0);
      tableCanvas.text("Weight: " + int(1000.0/testSwarm[i].agentDelay) + "/sec", 10*textSize,0);
      tableCanvas.text("Size: " + testSwarm[i].swarm.size() + " agents", 20*textSize,0);
      tableCanvas.translate(0, 1.5*textSize);
    }
    tableCanvas.translate(0, 1.5*textSize);
    tableCanvas.text("Total Swarms: " + testSwarm.length,0,0);
    tableCanvas.translate(0, 1.5*textSize);
    tableCanvas.text("Total Agents: " + numAgents,0,0);
    tableCanvas.popMatrix();
  }
  
  tableCanvas.endDraw();
  
  time_0 = millis();
}
  
