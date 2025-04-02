import javax.swing.*;
import java.awt.*;
import java.util.Random;
import java.util.ArrayList;
import java.util.Collections;

public class JogoMarcianoFinal extends JFrame {
    private final int LIMITE_TENTATIVAS = 8;
    private ArrayList<Integer> recordes = new ArrayList<>();
    
    // Componentes da tela inicial
    private JPanel initialPanel;
    private JButton iniciarButton, fecharButton1;
    private JTextArea historiaArea;
    private JLabel recordesLabel;
    
    // Componentes do jogo
    private JPanel gamePanel;
    private JLabel tentativaLabel;
    private JTextField entradaField;
    private JLabel mensagemLabel;
    private JLabel recordeAtualLabel;
    private JButton fecharButton2;
    
    // Componentes do fim de jogo
    private JPanel endPanel;
    private JButton fecharButton3;
    
    // Variáveis do jogo
    private int arvore;
    private int tentativas;

    public JogoMarcianoFinal() {
        initComponents();
        mostrarTelaInicial();
    }

    private void initComponents() {
        setTitle("Jogo do Marciano");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(500, 500);
        setLocationRelativeTo(null);
        setLayout(new CardLayout());

        // Tela inicial
        initialPanel = new JPanel(new BorderLayout(10, 10));
        initialPanel.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));
        
        JLabel tituloInicial = new JLabel("Jogo do Marciano", SwingConstants.CENTER);
        tituloInicial.setFont(new Font("Arial", Font.BOLD, 24));
        
        // Área de história com rolagem
        historiaArea = new JTextArea(
            "História:\n" +
            "Num planeta distante, um marciano veio visitar a Terra e se escondeu\n" +
            "entre as árvores numeradas de 1 a 100. Sua missão é encontrá-lo!\n\n" +
            "Regras:\n" +
            "- Você tem " + LIMITE_TENTATIVAS + " tentativas para adivinhar\n" +
            "- A cada palpite, você receberá uma dica se o marciano está em\n" +
            "  uma árvore maior ou menor\n" +
            "- Tente acertar com o menor número de tentativas possível!"
        );
        historiaArea.setFont(new Font("Arial", Font.PLAIN, 14));
        historiaArea.setEditable(false);
        historiaArea.setLineWrap(true);
        historiaArea.setWrapStyleWord(true);
        historiaArea.setBackground(getBackground());
        
        recordesLabel = new JLabel("Recordes: Nenhum recorde ainda", SwingConstants.CENTER);
        recordesLabel.setFont(new Font("Arial", Font.BOLD, 16));
        
        // Painel de botões da tela inicial
        JPanel botoesInicioPanel = new JPanel(new GridLayout(1, 2, 10, 10));
        iniciarButton = new JButton("Iniciar Jogo");
        iniciarButton.setFont(new Font("Arial", Font.BOLD, 16));
        iniciarButton.addActionListener(e -> iniciarJogo());
        
        fecharButton1 = new JButton("Fechar");
        fecharButton1.setFont(new Font("Arial", Font.BOLD, 16));
        fecharButton1.addActionListener(e -> System.exit(0));
        
        botoesInicioPanel.add(iniciarButton);
        botoesInicioPanel.add(fecharButton1);
        
        JPanel centerPanel = new JPanel();
        centerPanel.setLayout(new BoxLayout(centerPanel, BoxLayout.Y_AXIS));
        centerPanel.add(new JScrollPane(historiaArea));
        centerPanel.add(Box.createRigidArea(new Dimension(0, 15)));
        centerPanel.add(recordesLabel);
        centerPanel.add(Box.createRigidArea(new Dimension(0, 15)));
        centerPanel.add(botoesInicioPanel);
        
        initialPanel.add(tituloInicial, BorderLayout.NORTH);
        initialPanel.add(centerPanel, BorderLayout.CENTER);
        
        // Tela do jogo
        gamePanel = new JPanel();
        gamePanel.setLayout(new GridLayout(7, 1, 5, 5)); // Aumentei para 7 linhas
        gamePanel.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20));
        
        JLabel tituloJogo = new JLabel("Encontre o Marciano!", SwingConstants.CENTER);
        tituloJogo.setFont(new Font("Arial", Font.BOLD, 20));
        
        JLabel instrucaoLabel = new JLabel("Digite um número entre 1 e 100:", SwingConstants.CENTER);
        
        entradaField = new JTextField();
        entradaField.setHorizontalAlignment(JTextField.CENTER);
        
        JButton tentarButton = new JButton("Tentar");
        tentarButton.addActionListener(e -> verificarPalpite());
        
        tentativaLabel = new JLabel("Tentativa: 0/" + LIMITE_TENTATIVAS, SwingConstants.CENTER);
        recordeAtualLabel = new JLabel("Seu recorde: -", SwingConstants.CENTER);
        mensagemLabel = new JLabel("", SwingConstants.CENTER);
        
        fecharButton2 = new JButton("Fechar");
        fecharButton2.addActionListener(e -> System.exit(0));
        
        gamePanel.add(tituloJogo);
        gamePanel.add(instrucaoLabel);
        gamePanel.add(entradaField);
        gamePanel.add(tentarButton);
        gamePanel.add(tentativaLabel);
        gamePanel.add(recordeAtualLabel);
        gamePanel.add(mensagemLabel);
        gamePanel.add(fecharButton2);
        
        // Tela de fim de jogo
        endPanel = new JPanel(new BorderLayout(10, 20));
        endPanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        JLabel fimLabel = new JLabel("", SwingConstants.CENTER);
        fimLabel.setFont(new Font("Arial", Font.BOLD, 18));
        endPanel.add(fimLabel, BorderLayout.CENTER);
        
        JPanel botoesFimPanel = new JPanel(new GridLayout(1, 3, 10, 10));
        JButton reiniciarButton = new JButton("Jogar Novamente");
        reiniciarButton.addActionListener(e -> iniciarJogo());
        
        JButton voltarButton = new JButton("Voltar ao Início");
        voltarButton.addActionListener(e -> mostrarTelaInicial());
        
        fecharButton3 = new JButton("Fechar");
        fecharButton3.addActionListener(e -> System.exit(0));
        
        botoesFimPanel.add(reiniciarButton);
        botoesFimPanel.add(voltarButton);
        botoesFimPanel.add(fecharButton3);
        endPanel.add(botoesFimPanel, BorderLayout.SOUTH);
        
        // Adiciona todos os painéis
        add(initialPanel, "inicio");
        add(gamePanel, "jogo");
        add(endPanel, "fim");
    }

    private void mostrarTelaInicial() {
        atualizarRecordesLabel();
        ((CardLayout) getContentPane().getLayout()).show(getContentPane(), "inicio");
    }

    private void iniciarJogo() {
        Random random = new Random();
        arvore = random.nextInt(100) + 1;
        tentativas = 0;
        
        tentativaLabel.setText("Tentativa: 0/" + LIMITE_TENTATIVAS);
        mensagemLabel.setText("");
        entradaField.setText("");
        
        if (!recordes.isEmpty()) {
            recordeAtualLabel.setText("Seu recorde: " + Collections.min(recordes) + " tentativas");
        } else {
            recordeAtualLabel.setText("Seu recorde: -");
        }
        
        ((CardLayout) getContentPane().getLayout()).show(getContentPane(), "jogo");
        entradaField.requestFocus();
    }

    private void verificarPalpite() {
        try {
            int palpite = Integer.parseInt(entradaField.getText());
            
            if (palpite < 1 || palpite > 100) {
                mensagemLabel.setText("Digite um número entre 1 e 100!");
                return;
            }
            
            tentativas++;
            tentativaLabel.setText("Tentativa: " + tentativas + "/" + LIMITE_TENTATIVAS);
            
            if (palpite == arvore) {
                finalizarJogo(true);
                return;
            }
            
            if (tentativas >= LIMITE_TENTATIVAS) {
                finalizarJogo(false);
                return;
            }
            
            if (palpite > arvore) {
                mensagemLabel.setText("Está em uma árvore menor!");
            } else {
                mensagemLabel.setText("Está em uma árvore maior!");
            }
            
            entradaField.setText("");
        } catch (NumberFormatException ex) {
            mensagemLabel.setText("Digite um número válido!");
        }
    }

    private void finalizarJogo(boolean vitoria) {
        JLabel fimLabel = (JLabel) endPanel.getComponent(0);
        
        if (vitoria) {
            fimLabel.setText("<html>Parabéns!<br>Acertou em " + tentativas + " tentativas!</html>");
            recordes.add(tentativas);
            Collections.sort(recordes);
        } else {
            fimLabel.setText("<html>Game Over!<br>O marciano estava na árvore " + arvore + "</html>");
        }
        
        ((CardLayout) getContentPane().getLayout()).show(getContentPane(), "fim");
    }

    private void atualizarRecordesLabel() {
        if (recordes.isEmpty()) {
            recordesLabel.setText("Recordes: Nenhum recorde ainda");
        } else {
            StringBuilder sb = new StringBuilder("<html>Recordes:<br>");
            int max = Math.min(5, recordes.size());
            
            for (int i = 0; i < max; i++) {
                sb.append(i+1).append(". ").append(recordes.get(i)).append(" tentativas<br>");
            }
            
            sb.append("</html>");
            recordesLabel.setText(sb.toString());
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JogoMarcianoFinal jogo = new JogoMarcianoFinal();
            jogo.setVisible(true);
        });
    }
}
