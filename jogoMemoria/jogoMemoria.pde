// === Jogo da Memória com Animais ===

final int TOTAL_PARES = 9;
final int TOTAL_CARTAS = TOTAL_PARES * 2;
final int COLUNAS = 6;
final int LINHAS = 3;
final int LARGURA_CARTA = 100;
final int ALTURA_CARTA = 100;

PImage[][] temas = new PImage[3][TOTAL_PARES]; // 0: gatos, 1: cachorros, 2: passaros
String[] nomesTemas = {"Gatos", "Cachorros", "Passaros"};
int temaSelecionado = -1;

int[] embaralhamento = new int[TOTAL_CARTAS];
boolean[] cartaVirada = new boolean[TOTAL_CARTAS];
boolean[] cartaFixa = new boolean[TOTAL_CARTAS];

int primeiraCarta = -1;
int segundaCarta = -1;
boolean aguardando = false;
int tempoVirada;

PFont fonte;
String estado = "inicio";
int tempoInicio;
int tempoLimite = 60;

void setup() {
  size(800, 600);
  fonte = createFont("Arial", 20, true);

  for (int t = 0; t < 3; t++) {
    for (int i = 0; i < TOTAL_PARES; i++) {
      String nomeBase = "";
      if (t == 0) nomeBase = "gato";
      if (t == 1) nomeBase = "cachorro";
      if (t == 2) nomeBase = "passaro";
      temas[t][i] = loadImage(nomeBase + i + ".jpg");
      temas[t][i].resize(LARGURA_CARTA, ALTURA_CARTA);
    }
  }

  embaralharCartas();
}

void draw() {
  background(200);

  if (estado.equals("inicio")) {
    telaInicio();
  } else if (estado.equals("jogando")) {
    telaJogo();
    mostrarTempo();
    verificarVitoria();
  } else if (estado.equals("fim")) {
    telaFinal();
  }

  if (aguardando) {
    if (embaralhamento[primeiraCarta] == embaralhamento[segundaCarta]) {
      cartaFixa[primeiraCarta] = true;
      cartaFixa[segundaCarta] = true;
      primeiraCarta = -1;
      segundaCarta = -1;
      aguardando = false;
    } else if (millis() - tempoVirada > 1000) {
      cartaVirada[primeiraCarta] = false;
      cartaVirada[segundaCarta] = false;
      primeiraCarta = -1;
      segundaCarta = -1;
      aguardando = false;
    }
  }
}

void telaInicio() {
  textFont(fonte);
  textAlign(CENTER);
  fill(0);
  textSize(32);
  text("Jogo da Memória", width / 2, 80);

  textSize(20);
  text("Escolha um tema:", width / 2, 140);

  for (int i = 0; i < nomesTemas.length; i++) {
    int x = width / 2 - 110;
    int y = 180 + i * 70;
    fill(temaSelecionado == i ? color(100, 200, 100) : 0);
    rect(x, y, 220, 40);
    fill(255);
    text(nomesTemas[i], width / 2, y + 27);
  }

  if (temaSelecionado != -1) {
    fill(0);
    rect(width / 2 - 100, 450, 200, 40);
    fill(255);
    text("Iniciar Jogo", width / 2, 477);
  }

  fill(255, 0, 0);
  rect(width - 110, 20, 90, 30);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Sair", width - 65, 35);
}

void telaJogo() {
  for (int i = 0; i < TOTAL_CARTAS; i++) {
    int x = (i % COLUNAS) * (LARGURA_CARTA + 10) + 50;
    int y = (i / COLUNAS) * (ALTURA_CARTA + 10) + 100;

    if (cartaFixa[i] || cartaVirada[i]) {
      image(temas[temaSelecionado][embaralhamento[i]], x, y);
    } else {
      fill(100);
      rect(x, y, LARGURA_CARTA, ALTURA_CARTA);
    }
  }

  fill(255, 0, 0);
  rect(width - 110, 20, 90, 30);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Sair", width - 65, 35);
}

void telaFinal() {
  background(estadoVitoria() ? color(0, 200, 0) : color(200, 0, 0));
  fill(255);
  textFont(fonte);
  textSize(28);
  textAlign(CENTER, CENTER);
  text(estadoVitoria() ? "Você Ganhou!" : "Tempo Esgotado!", width / 2, height / 2 - 100);

  textSize(20);
  fill(0);
  rect(width / 2 - 120, height / 2 - 20, 240, 40);
  fill(255);
  text("Jogar Novamente", width / 2, height / 2);

  fill(0);
  rect(width / 2 - 120, height / 2 + 40, 240, 40);
  fill(255);
  text("Voltar ao Início", width / 2, height / 2 + 60);

  fill(0);
  rect(width / 2 - 120, height / 2 + 100, 240, 40);
  fill(255);
  text("Sair", width / 2, height / 2 + 120);
}

void mousePressed() {
  if (estado.equals("inicio")) {
    for (int i = 0; i < nomesTemas.length; i++) {
      int y = 180 + i * 70;
      if (mouseX > width / 2 - 110 && mouseX < width / 2 + 110 && mouseY > y && mouseY < y + 40) {
        temaSelecionado = i;
      }
    }

    if (temaSelecionado != -1 && mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > 450 && mouseY < 490) {
      reiniciarJogo(); // <- IMPORTANTE!
      estado = "jogando";
    }

    if (mouseX > width - 110 && mouseX < width - 20 && mouseY > 20 && mouseY < 50) {
      exit();
    }
  } else if (estado.equals("jogando")) {
    if (mouseX > width - 110 && mouseX < width - 20 && mouseY > 20 && mouseY < 50) {
      exit();
    }

    if (!aguardando) {
      for (int i = 0; i < TOTAL_CARTAS; i++) {
        int x = (i % COLUNAS) * (LARGURA_CARTA + 10) + 50;
        int y = (i / COLUNAS) * (ALTURA_CARTA + 10) + 100;

        if (!cartaFixa[i] && !cartaVirada[i] && mouseX > x && mouseX < x + LARGURA_CARTA && mouseY > y && mouseY < y + ALTURA_CARTA) {
          cartaVirada[i] = true;
          if (primeiraCarta == -1) {
            primeiraCarta = i;
          } else if (segundaCarta == -1 && i != primeiraCarta) {
            segundaCarta = i;
            aguardando = true;
            tempoVirada = millis();
          }
          break;
        }
      }
    }
  } else if (estado.equals("fim")) {
    if (mouseX > width / 2 - 120 && mouseX < width / 2 + 120) {
      if (mouseY > height / 2 - 20 && mouseY < height / 2 + 20) {
        reiniciarJogo();
        estado = "jogando";
      } else if (mouseY > height / 2 + 40 && mouseY < height / 2 + 80) {
        estado = "inicio";
        temaSelecionado = -1;
      } else if (mouseY > height / 2 + 100 && mouseY < height / 2 + 140) {
        exit();
      }
    }
  }
}

void mostrarTempo() {
  int tempoRestante = tempoLimite - (millis() - tempoInicio) / 1000;
  fill(0);
  textSize(20);
  textAlign(LEFT);
  text("Tempo: " + tempoRestante + "s", 20, 30);
  if (tempoRestante <= 0) estado = "fim";
}

void verificarVitoria() {
  for (boolean fixa : cartaFixa) {
    if (!fixa) return;
  }
  estado = "fim";
}

boolean estadoVitoria() {
  for (boolean fixa : cartaFixa) {
    if (!fixa) return false;
  }
  return true;
}

void embaralharCartas() {
  int[] pares = new int[TOTAL_CARTAS];
  for (int i = 0; i < TOTAL_PARES; i++) {
    pares[i * 2] = i;
    pares[i * 2 + 1] = i;
  }
  for (int i = 0; i < TOTAL_CARTAS; i++) {
    int r = int(random(i, TOTAL_CARTAS));
    int temp = pares[i];
    pares[i] = pares[r];
    pares[r] = temp;
  }
  for (int i = 0; i < TOTAL_CARTAS; i++) {
    embaralhamento[i] = pares[i];
    cartaVirada[i] = false;
    cartaFixa[i] = false;
  }
}

void reiniciarJogo() {
  embaralharCartas();
  primeiraCarta = -1;
  segundaCarta = -1;
  aguardando = false;
  tempoInicio = millis();
}
