static final String[] forestName = {
  "Forest Humming", "Forest Sting", "Forest Wax", "Forest Beetle", "Forest King", "Forest Glow", "Forest Dark", "Guardian School", "Forest Light", "Forest Amazing", "Jumbee Valley", "Dream Land", "Penisula Giant"
};
static final int[] forestCost = {
  0, 1500, 2500, 5000, 15000, 35000, 70000, 100000, 180000, 500000, 600000, 1500000, 2000000
};
static final int[][] forestHoneyRng = {
  {1, 3}, {3, 9}, {7, 15}, {10, 25}, {15, 35}, {25, 48}, {35, 62}, {0, 0}, {50, 85}, {100, 175}, {0, 0}, {200, 350}, {325, 500}
};
//static final int[][] forestFlowerSpawnRate = {{}, {}, {}, {}, {}, {}, {}, {0,0}, {}, {}, {0,0}, {}, {}};

ArrayList<CircleButton> forestBtns = new ArrayList<CircleButton>();

void showForestMenu() {
  //sellAllHoneyBtn.Draw();
  showMarketBtn.updateGreyOut(false);
  honeyFlucBtn.updateGreyOut(false);
  bottomStatsBar();

  for (int fb = forestBtns.size()-1; fb >= 0; fb--) {
    CircleButton _forestBtn = forestBtns.get(fb);

    if (money < forestCost[fb]) _forestBtn.updateGreyOut(true);
    else _forestBtn.updateGreyOut(false);
    _forestBtn.Draw();
  }

  if (ERRORForestNEM) {
    fill(0);
    textAlign(LEFT);
    text("You don't have enough money!", 50, height-50);
  }
}

int forestType = 0; //which forest player is in
boolean ERRORForestNEM = false;
void initializeForest(int _forestType) {
  ERRORForestNEM = false;
  if (money >= forestCost[_forestType]) {
    if (week+1 > GAME_WEEK_LENGTH) gameOver = true;
    else week++;

    forestType = _forestType;
    gameMillis = 0;
    roundTime = 0;
    pMillis = timeMillis;
    flowerTimer = 0;
    honeyPriceChgTimer = 0;
    hornetTimer = 0;
    trainingFadeOutTimer = 0;

    money -= forestCost[_forestType];

    flowers = new ArrayList<Flower>();

    screenDisable();
    gameScreenActive = true;

    //remove all hornets, fireflies
    hornets = new ArrayList<Hornet>();
    fireflies = new ArrayList<Firefly>();

    //create flowers
    for (int i=0; i<10; i++) { 
      flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[_forestType][0], forestHoneyRng[_forestType][1]));
    }

    //reset bees
    for (Bee b : bees) {
      b.updateLocation(width/2, height/2);
      b.resetRadius();
      b.updateShouldBeeMove(true);
      b.updateBeeMoveTimer(0);
    }

    for (Guardian g : guardians) {
      g.updateLocation(width/2, height/2);
      g.resetRadius();
      g.updateShouldGuardianMove(true);
      g.updateGuardianMoveTimer(0);
    }

    //initiate guardian training (if available)
    if (GTPurchased) {
      GTPurchased = false;
      GTOngoing = true;

      for (int _g = guardians.size()-1; _g >= 0; _g--) {
        Guardian g = guardians.get(_g);
        if (g.getGuardianName().equals(guardianName[1])) {
          guardians.remove(_g);
          break;
        }
      }

      trainingGuardian = new TrainingGuardian(GTSelected);

      switch (GTSelected) {
      case 0: //Royal Guardian
        GTObjectiveAddAmount = 5;
        for (int i = 0; i < 5; i++) {
          trainingFireflies.add(new Firefly(true));
        }
        break;
      }
    }
  } else {
    ERRORForestNEM = true;
  }
}