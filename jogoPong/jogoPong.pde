// Estados do jogo
final int MENU = 0;
final int SELECAO = 1;
final int DIFICULDADE = 2;
final int JOGO = 3;
final int FIM = 4;
int estadoAtual = MENU;

PFont fonte;

// Botões
Botao botaoJogar, botaoSair, botaoVsPlayer, botaoVsCPU, botaoVoltar;
Botao botaoDificil, botaoMedio, botaoFacil; // Botões de dificuldade

boolean modoVsCPU = false;

// Variáveis do jogo
int pontosEsq = 0, pontosDir = 0;
Paddle paddleEsq, paddleDir;
Ball bola;

float dificuldade = 0.07; // Definindo a dificuldade inicial
float tamanhoPaddleEsq = 80; // Tamanho inicial da paleta do jogador 1
float tamanhoPaddleDir = 80; // Tamanho inicial da paleta do jogador 2
float velocidadeBola = 5; // Velocidade inicial da bola

void setup() {
  size(800, 500);
  fonte = createFont("Arial", 20);
  textFont(fonte);
  
  botaoJogar = new Botao("Jogar", width/2 - 75, height/2 - 40, 150, 40);
  botaoSair = new Botao("Sair", width/2 - 75, height/2 + 20, 150, 40);
  
  botaoVsPlayer = new Botao("2 Jogadores", width/2 - 85, height/2 - 40, 170, 40);
  botaoVsCPU = new Botao("Contra CPU", width/2 - 85, height/2 + 20, 170, 40);
  
  botaoVoltar = new Botao("Voltar", 10, 10, 100, 30);
  
  // Botões de dificuldade corrigidos
  botaoDificil = new Botao("Difícil", width/2 - 75, height/2 - 60, 150, 40); // "Fácil" será o mais difícil
  botaoMedio = new Botao("Médio", width/2 - 75, height/2, 150, 40);
  botaoFacil = new Botao("Fácil", width/2 - 75, height/2 + 60, 150, 40); // "Difícil" será o mais fácil
  
  iniciarJogo();
}

void draw() {
  background(30);
  
  switch (estadoAtual) {
    case MENU:
      mostrarMenu();
      break;
    case SELECAO:
      mostrarSelecao();
      break;
    case DIFICULDADE:
      mostrarDificuldade(); // Tela de seleção de dificuldade
      break;
    case JOGO:
      jogar();
      break;
    case FIM:
      mostrarFim();
      break;
  }
}

void mousePressed() {
  if (estadoAtual == MENU) {
    if (botaoJogar.clicado(mouseX, mouseY)) {
      estadoAtual = SELECAO;
    } else if (botaoSair.clicado(mouseX, mouseY)) {
      exit();
    }
  } else if (estadoAtual == SELECAO) {
    if (botaoVsPlayer.clicado(mouseX, mouseY)) {
      // Modo "2 Jogadores" usa a dificuldade média automaticamente
      modoVsCPU = false;
      dificuldade = 0.10; // Configuração de dificuldade média
      tamanhoPaddleEsq = 80; // Paleta normal
      tamanhoPaddleDir = 80; // Paleta normal
      velocidadeBola = 5; // Velocidade normal da bola
      iniciarJogo();
      estadoAtual = JOGO;
    } else if (botaoVsCPU.clicado(mouseX, mouseY)) {
      modoVsCPU = true;
      estadoAtual = DIFICULDADE; // Vai para a tela de seleção de dificuldade
    }
  } else if (estadoAtual == DIFICULDADE) {
    if (botaoDificil.clicado(mouseX, mouseY)) {
      dificuldade = 0.90; // "Fácil" será o modo mais difícil
      tamanhoPaddleEsq = 40; // Reduz a paleta pela metade no modo difícil
      tamanhoPaddleDir = 80; // A paleta da máquina permanece a mesma
      velocidadeBola = 10; // Aumenta a velocidade da bola no modo difícil
      iniciarJogo();
      estadoAtual = JOGO;
    } else if (botaoMedio.clicado(mouseX, mouseY)) {
      dificuldade = 0.10; 
      tamanhoPaddleEsq = 80; // Paleta normal
      tamanhoPaddleDir = 80; // Paleta normal
      velocidadeBola = 5; // Velocidade normal da bola
      iniciarJogo();
      estadoAtual = JOGO;
    } else if (botaoFacil.clicado(mouseX, mouseY)) {
      dificuldade = 0.03; // "Difícil" será o modo mais fácil
      tamanhoPaddleEsq = 80; // Paleta normal
      tamanhoPaddleDir = 80; // Paleta normal
      velocidadeBola = 2; // Velocidade normal da bola
      iniciarJogo();
      estadoAtual = JOGO;
    }
  } else if (estadoAtual == JOGO) {
    if (botaoVoltar.clicado(mouseX, mouseY)) {
      estadoAtual = MENU;
    }
  } else if (estadoAtual == FIM) {
    if (botaoVoltar.clicado(mouseX, mouseY)) {
      estadoAtual = MENU;
    }
  }
}

void keyPressed() {
  if (estadoAtual == JOGO) {
    if (key == 'w') paddleEsq.mover(-1);
    if (key == 's') paddleEsq.mover(1);
    if (!modoVsCPU) {
      if (keyCode == UP) paddleDir.mover(-1);
      if (keyCode == DOWN) paddleDir.mover(1);
    }
  }
}

void keyReleased() {
  if (estadoAtual == JOGO) {
    paddleEsq.parar();
    paddleDir.parar();
  }
}

void mostrarMenu() {
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("PONG", width/2, 120);
  
  botaoJogar.desenhar();
  botaoSair.desenhar();
}

void mostrarSelecao() {
  fill(255);
  textAlign(CENTER);
  textSize(25);
  text("Escolha o modo de jogo:", width/2, 120);
  
  botaoVsPlayer.desenhar();
  botaoVsCPU.desenhar();
}

void mostrarDificuldade() { // Tela de seleção de dificuldade
  fill(255);
  textAlign(CENTER);
  textSize(25);
  text("Escolha a dificuldade:", width/2, 120);
  
  botaoDificil.desenhar(); // "Fácil" é o mais difícil
  botaoMedio.desenhar(); // Média dificuldade
  botaoFacil.desenhar(); // "Difícil" é o mais fácil
}

void mostrarFim() {
  fill(255);
  textAlign(CENTER);
  textSize(28);
  String vencedor = pontosEsq == 7 ? "Jogador 1 venceu!" : "Jogador 2 venceu!";
  if (modoVsCPU && pontosDir == 7) vencedor = "CPU venceu!";
  text(vencedor, width/2, height/2 - 20);
  
  botaoVoltar.desenhar();
}

void iniciarJogo() {
  pontosEsq = 0;
  pontosDir = 0;
  paddleEsq = new Paddle(30, tamanhoPaddleEsq);  
  paddleDir = new Paddle(width - 40, tamanhoPaddleDir);  
  bola = new Ball();
}

void jogar() {
  paddleEsq.atualizar();
  paddleDir.atualizar();
  bola.atualizar();
  
  if (modoVsCPU) {
    paddleDir.seguirBola(bola);
  }
  
  paddleEsq.desenhar();
  paddleDir.desenhar();
  bola.desenhar();
  
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text(pontosEsq + " : " + pontosDir, width/2, 40);
  
  botaoVoltar.desenhar();
  
  if (pontosEsq >= 7 || pontosDir >= 7) {
    estadoAtual = FIM;
  }
}

class Botao {
  String texto;
  float x, y, w, h;
  
  Botao(String texto, float x, float y, float w, float h) {
    this.texto = texto;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void desenhar() {
    fill(70);
    stroke(255);
    rect(x, y, w, h, 8);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(texto, x + w/2, y + h/2);
  }
  
  boolean clicado(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

class Paddle {
  float x, y, w, h;
  float velocidade = 5;
  float dy = 0;
  
  Paddle(float x, float h) {
    this.x = x;
    this.h = h;
    this.w = 15;
    this.y = height/2 - h/2;
  }
  
  void atualizar() {
    y += dy;
    y = constrain(y, 0, height - h);
  }
  
  void desenhar() {
    fill(255);
    rect(x, y, w, h);
  }
  
  void mover(int dir) {
    dy = dir * velocidade;
  }
  
  void parar() {
    dy = 0;
  }
  
  void seguirBola(Ball b) {
    float centro = y + h/2;
    float erro = b.y - centro;

    dy = erro * dificuldade;

    float maxVelocidade = 4;
    dy = constrain(dy, -maxVelocidade, maxVelocidade);
  }
}

class Ball {
  float x, y, r = 12;
  float vx, vy;
  float velocidade = 5;
  
  Ball() {
    resetar();
  }
  
  void resetar() {
    x = width/2;
    y = height/2;
    vx = random(1) > 0.5 ? velocidade : -velocidade;
    vy = random(-3, 3);
  }
  
  void atualizar() {
    x += vx;
    y += vy;
    
    if (y < 0 || y > height) vy *= -1;
    
    if (colidiu(paddleEsq) || colidiu(paddleDir)) {
      vx *= -1.05;
      vy = random(-4, 4);
    }
    
    if (x < 0) {
      pontosDir++;
      resetar();
    }
    
    if (x > width) {
      pontosEsq++;
      resetar();
    }
  }
  
  void desenhar() {
    fill(255);
    ellipse(x, y, r*2, r*2);
  }
  
  boolean colidiu(Paddle p) {
    return x - r < p.x + p.w && x + r > p.x && y > p.y && y < p.y + p.h;
  }
}
