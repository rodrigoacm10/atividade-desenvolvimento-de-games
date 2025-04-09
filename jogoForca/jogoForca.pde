// Jogo da Forca (Hangman) em Processing
// Autor: [Seu Nome]
// Data: [Data]

// Variáveis do jogo
String[] temas = {"Frutas", "Cidades", "Animais", "Países"};
String[][] palavrasPorTema;
String palavraSecreta = "";
String letrasErradas = "";
String letrasCorretas = "";
int temaSelecionado = 0;
int estadoJogo = 0; // 0=menu, 1=jogando, 2=ganhou, 3=perdeu
int tentativasRestantes = 6;

// Imagens
PImage[] imagensForca;
PImage imagemFundo;

void setup() {
  size(800, 600);
  smooth();
  
  // Inicializar banco de dados de palavras
  inicializarBancoDeDados();
  
  // Carregar imagens
  carregarImagens();
  
  // Selecionar tema e palavra aleatória
  selecionarPalavraAleatoria();
}

void draw() {
  background(240);
  
  switch(estadoJogo) {
    case 0: // Menu
      desenharMenu();
      break;
    case 1: // Jogando
      desenharJogo();
      break;
    case 2: // Ganhou
      desenharVitoria();
      break;
    case 3: // Perdeu
      desenharDerrota();
      break;
  }
}

void keyPressed() {
  if (estadoJogo == 1) { // Durante o jogo
    if (key >= 'a' && key <= 'z') {
      char letra = key;
      verificarLetra(letra);
    }
  } else if (estadoJogo == 2 || estadoJogo == 3) { // Fim de jogo
    if (key == ' ') {
      reiniciarJogo();
    }
  }
}

void mousePressed() {
  if (estadoJogo == 0) { // Menu
    for (int i = 0; i < temas.length; i++) {
      if (mouseX > 300 && mouseX < 500 && mouseY > 200 + i*60 && mouseY < 240 + i*60) {
        temaSelecionado = i;
        estadoJogo = 1;
        selecionarPalavraAleatoria();
        break;
      }
    }
  }
}

void inicializarBancoDeDados() {
  palavrasPorTema = new String[temas.length][];
  
  // Palavras por tema
  palavrasPorTema[0] = new String[]{"banana", "maca", "laranja", "abacaxi", "morango", "uva", "melancia", "kiwi"};
  palavrasPorTema[1] = new String[]{"sao paulo", "rio de janeiro", "belo horizonte", "brasilia", "salvador", "curitiba", "fortaleza", "recife"};
  palavrasPorTema[2] = new String[]{"cachorro", "gato", "elefante", "girafa", "tigre", "leao", "macaco", "zebra"};
  palavrasPorTema[3] = new String[]{"brasil", "argentina", "canada", "japao", "australia", "alemanha", "franca", "italia"};
}

void carregarImagens() {
  imagensForca = new PImage[7];
  for (int i = 0; i < 7; i++) {
    imagensForca[i] = loadImage("forca" + i + ".png");
  }
  imagemFundo = loadImage("fundo.jpg");
}

void selecionarPalavraAleatoria() {
  letrasErradas = "";
  letrasCorretas = "";
  tentativasRestantes = 6;
  
  String[] palavrasDoTema = palavrasPorTema[temaSelecionado];
  int indice = (int)random(palavrasDoTema.length);
  palavraSecreta = palavrasDoTema[indice];
}

void verificarLetra(char letra) {
  // Verificar se a letra já foi tentada
  if (letrasErradas.indexOf(letra) >= 0 || letrasCorretas.indexOf(letra) >= 0) {
    return;
  }
  
  // Verificar se a letra está na palavra
  if (palavraSecreta.indexOf(letra) >= 0) {
    letrasCorretas += letra;
    
    // Verificar se ganhou
    boolean ganhou = true;
    for (int i = 0; i < palavraSecreta.length(); i++) {
      char c = palavraSecreta.charAt(i);
      if (c != ' ' && letrasCorretas.indexOf(c) < 0) {
        ganhou = false;
        break;
      }
    }
    
    if (ganhou) {
      estadoJogo = 2;
    }
  } else {
    letrasErradas += letra;
    tentativasRestantes--;
    
    if (tentativasRestantes <= 0) {
      estadoJogo = 3;
    }
  }
}

void reiniciarJogo() {
  estadoJogo = 0;
}

void desenharMenu() {
  // Fundo
  if (imagemFundo != null) {
    image(imagemFundo, 0, 0, width, height);
  } else {
    background(200, 220, 255);
  }
  
  // Título
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Jogo da Forca", width/2, 100);
  
  // Subtítulo
  textSize(24);
  text("Escolha um tema:", width/2, 160);
  
  // Botões de tema
  for (int i = 0; i < temas.length; i++) {
    fill(100, 150, 255);
    rect(300, 200 + i*60, 200, 40, 10);
    fill(255);
    textSize(20);
    text(temas[i], 400, 220 + i*60);
  }
}

void desenharJogo() {
  // Fundo
  background(255);
  
  // Desenhar forca
  if (imagensForca != null && imagensForca[6 - tentativasRestantes] != null) {
    image(imagensForca[6 - tentativasRestantes], 50, 100, 300, 300);
  } else {
    desenharForcaBasica();
  }
  
  // Informações do jogo
  fill(0);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Tema: " + temas[temaSelecionado], 400, 100);
  text("Tentativas restantes: " + tentativasRestantes, 400, 140);
  
  // Letras erradas
  text("Letras erradas: " + letrasErradas, 400, 180);
  
  // Palavra secreta
  String palavraExibida = "";
  for (int i = 0; i < palavraSecreta.length(); i++) {
    char c = palavraSecreta.charAt(i);
    if (c == ' ') {
      palavraExibida += " ";
    } else if (letrasCorretas.indexOf(c) >= 0) {
      palavraExibida += c + " ";
    } else {
      palavraExibida += "_ ";
    }
  }
  
  textSize(32);
  textAlign(CENTER, CENTER);
  text(palavraExibida, width/2, 300);
  
  // Instruções
  textSize(16);
  text("Digite uma letra", width/2, 350);
}

void desenharForcaBasica() {
  stroke(0);
  strokeWeight(4);
  
  // Base
  line(100, 400, 250, 400);
  // Poste
  line(150, 400, 150, 150);
  // Topo
  line(150, 150, 250, 150);
  // Corda
  line(250, 150, 250, 180);
  
  // Cabeça
  if (tentativasRestantes < 6) {
    ellipse(250, 200, 40, 40);
  }
  
  // Corpo
  if (tentativasRestantes < 5) {
    line(250, 220, 250, 300);
  }
  
  // Braço esquerdo
  if (tentativasRestantes < 4) {
    line(250, 240, 220, 260);
  }
  
  // Braço direito
  if (tentativasRestantes < 3) {
    line(250, 240, 280, 260);
  }
  
  // Perna esquerda
  if (tentativasRestantes < 2) {
    line(250, 300, 220, 330);
  }
  
  // Perna direita
  if (tentativasRestantes < 1) {
    line(250, 300, 280, 330);
  }
}

void desenharVitoria() {
  // Fundo
  background(200, 255, 200);
  
  // Mensagem
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Você Ganhou!", width/2, 150);
  
  // Palavra
  textSize(32);
  text("A palavra era: " + palavraSecreta, width/2, 220);
  
  // Imagem de vitória
  if (imagensForca != null && imagensForca[6] != null) {
    image(imagensForca[6], width/2 - 150, 280, 300, 300);
  }
  
  // Instrução
  textSize(24);
  text("Pressione ESPAÇO para jogar novamente", width/2, 500);
}

void desenharDerrota() {
  // Fundo
  background(255, 200, 200);
  
  // Mensagem
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Você Perdeu!", width/2, 150);
  
  // Palavra
  textSize(32);
  text("A palavra era: " + palavraSecreta, width/2, 220);
  
  // Imagem de derrota
  if (imagensForca != null && imagensForca[6] != null) {
    image(imagensForca[6], width/2 - 150, 280, 300, 300);
  }
  
  // Instrução
  textSize(24);
  text("Pressione ESPAÇO para jogar novamente", width/2, 500);
}
