
// Variáveis globais
int boardSize = 300; // Tamanho do tabuleiro
int cellSize = boardSize / 3; // Tamanho de cada célula
int[][] board = new int[3][3]; // 0 = vazio, 1 = X, 2 = O
int currentPlayer = 1; // Começa com X
boolean gameOver = false;
int winner = 0; // 0 = sem vencedor, 1 = X, 2 = O, 3 = empate
boolean vsComputer = false; // Modo de jogo (true = vs computador, false = vs jogador)

void setup() {
  size(400, 450); // Largura x Altura (incluindo espaço para botões)
  resetGame();
  
  // Configuração do texto
  textSize(24);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);
  
  // Desenha o tabuleiro
  drawBoard();
  
  // Desenha as marcações (X e O)
  drawMarks();
  
  // Desenha o status do jogo
  drawStatus();
  
  // Desenha os botões
  drawButtons();
  
  // Verifica se é a vez do computador no modo vs computador
  if (vsComputer && currentPlayer == 2 && !gameOver) {
    delay(500); // Pequeno atraso para parecer mais natural
    computerMove();
  }
}

void drawBoard() {
  strokeWeight(3);
  line(50, 150, 350, 150); // Linha horizontal superior
  line(50, 250, 350, 250); // Linha horizontal inferior
  line(150, 50, 150, 350); // Linha vertical esquerda
  line(250, 50, 250, 350); // Linha vertical direita
}

void drawMarks() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = 50 + j * cellSize + cellSize/2;
      float y = 50 + i * cellSize + cellSize/2;
      
      if (board[i][j] == 1) { // X
        stroke(255, 0, 0);
        line(x - 30, y - 30, x + 30, y + 30);
        line(x + 30, y - 30, x - 30, y + 30);
      } else if (board[i][j] == 2) { // O
        stroke(0, 0, 255);
        noFill();
        ellipse(x, y, 60, 60);
      }
    }
  }
}

void drawStatus() {
  fill(0);
  textSize(20);
  
  if (gameOver) {
    if (winner == 3) {
      text("Empate!", width/2, 20);
    } else if (winner == 1) {
      text("X venceu!", width/2, 20);
    } else if (winner == 2) {
      text("O venceu!", width/2, 20);
    }
  } else {
    if (currentPlayer == 1) {
      text("Vez do X", width/2, 20);
    } else {
      text("Vez do O", width/2, 20);
    }
  }
  
  // Mostra o modo de jogo
  textSize(16);
  if (vsComputer) {
    text("Modo: vs Computador", width/2, 400);
  } else {
    text("Modo: 2 Jogadores", width/2, 400);
  }
}

void drawButtons() {
  // Botão de reiniciar
  fill(200);
  rect(100, 420, 100, 30);
  fill(0);
  textSize(16);
  text("Reiniciar", 150, 435);
  
  // Botão de trocar modo
  fill(200);
  rect(220, 420, 160, 30);
  fill(0);
  text("Trocar Modo", 300, 435);
}

void mousePressed() {
  // Verifica clique nos botões
  if (mouseX >= 100 && mouseX <= 200 && mouseY >= 420 && mouseY <= 450) {
    resetGame();
    return;
  }
  
  if (mouseX >= 220 && mouseX <= 380 && mouseY >= 420 && mouseY <= 450) {
    vsComputer = !vsComputer;
    resetGame();
    return;
  }
  
  // Se o jogo acabou, não processa cliques no tabuleiro
  if (gameOver) return;
  
  // Verifica se o clique foi dentro do tabuleiro
  if (mouseX >= 50 && mouseX <= 350 && mouseY >= 50 && mouseY <= 350) {
    int row = (mouseY - 50) / cellSize;
    int col = (mouseX - 50) / cellSize;
    
    // Verifica se a célula está vazia
    if (board[row][col] == 0) {
      board[row][col] = currentPlayer;
      
      // Verifica se houve vencedor
      checkWinner();
      
      // Troca o jogador se o jogo não acabou
      if (!gameOver) {
        currentPlayer = (currentPlayer == 1) ? 2 : 1;
      }
    }
  }
}

void checkWinner() {
  // Verifica linhas
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != 0 && board[i][0] == board[i][1] && board[i][0] == board[i][2]) {
      gameOver = true;
      winner = board[i][0];
      return;
    }
  }
  
  // Verifica colunas
  for (int j = 0; j < 3; j++) {
    if (board[0][j] != 0 && board[0][j] == board[1][j] && board[0][j] == board[2][j]) {
      gameOver = true;
      winner = board[0][j];
      return;
    }
  }
  
  // Verifica diagonais
  if (board[0][0] != 0 && board[0][0] == board[1][1] && board[0][0] == board[2][2]) {
    gameOver = true;
    winner = board[0][0];
    return;
  }
  
  if (board[0][2] != 0 && board[0][2] == board[1][1] && board[0][2] == board[2][0]) {
    gameOver = true;
    winner = board[0][2];
    return;
  }
  
  // Verifica empate
  boolean isTie = true;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        isTie = false;
        break;
      }
    }
    if (!isTie) break;
  }
  
  if (isTie) {
    gameOver = true;
    winner = 3; // Empate
  }
}

void computerMove() {
  // Primeiro, verifica se pode vencer na próxima jogada
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        board[i][j] = 2; // O é o computador
        checkWinner();
        if (gameOver && winner == 2) {
          return; // Computador vence
        } else {
          board[i][j] = 0; // Desfaz a jogada
          gameOver = false;
          winner = 0;
        }
      }
    }
  }
  
  // Depois, verifica se precisa bloquear o jogador humano
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        board[i][j] = 1; // X é o jogador humano
        checkWinner();
        if (gameOver && winner == 1) {
          board[i][j] = 2; // Bloqueia
          gameOver = false;
          winner = 0;
          currentPlayer = 1; // Passa a vez para o jogador humano
          return;
        } else {
          board[i][j] = 0; // Desfaz a jogada
          gameOver = false;
          winner = 0;
        }
      }
    }
  }
  
  // Se não houver jogadas críticas, faz uma jogada aleatória
  ArrayList<PVector> emptyCells = new ArrayList<PVector>();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        emptyCells.add(new PVector(i, j));
      }
    }
  }
  
  if (emptyCells.size() > 0) {
    int randomIndex = (int)random(emptyCells.size());
    PVector move = emptyCells.get(randomIndex);
    board[(int)move.x][(int)move.y] = 2;
    checkWinner();
    currentPlayer = 1; // Passa a vez para o jogador humano
  }
}

void resetGame() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = 0;
    }
  }
  currentPlayer = 1;
  gameOver = false;
  winner = 0;
}
