# robo-trader-fibonnaci
Este repositório contém um exemplo de robô de trading desenvolvido em MQL5 para a plataforma MetaTrader. O robô utiliza médias móveis e análise de canais baseados em barras semanais para identificar oportunidades de compra e venda, calculando automaticamente o tamanho do lote com base no risco definido. 

# Exemplo de Robô de Trading para MetaTrader 5 (MT5)

Este projeto é um exemplo prático de um robô de negociação automática desenvolvido em MQL para a plataforma MetaTrader 5 (MT5). Ele utiliza uma estratégia inspirada nos canais de Fibonacci, extraídos da vela semanal anterior, para identificar oportunidades de entrada e saída, com um robusto sistema de gerenciamento de risco.

## Funcionalidades

- **Divisão da Vela Semanal:**
  - Identifica a mínima e a máxima da vela semanal anterior, criando apenas um canal de negociação por semana.
  - Divide a amplitude da vela em 4 canais (25%, 50%, 75% e 100%), aproximando uma análise dos níveis de Fibonacci.

- **Critério de Entrada:**
  - Monitora as velas de 15 minutos (M15).
  - todas as entradas acontecem apenas quando há fechamento de vela, então a vela tem que abrir abaixo e fechar acima ou abrir acima ou fechar abaixo do ponto de entrada.
  - O ponto de entrada é 50% de qualquer um dos 4 canais.
  - Executa uma ordem de **compra** quando o preço rompe o nível de 50% para cima de um canal.
  - Executa uma ordem de **venda** quando o preço rompe o nível de 50% para baixo de um canal.
  - Garante que não haja novas ordens se já houver uma posição ativa para o mesmo símbolo e magic number.

- **Cálculo do Tamanho do Lote:**
  - O usuário define um risco fixo em USD para cada operação.
  - O robô calcula dinamicamente o tamanho do lote com base na distância entre o preço de entrada e o stop loss, considerando o valor do pip do ativo.
  - Fórmula utilizada:  
    Lote = Risco / (Variação do Stop Loss / Valor do Pip)  
    Isso assegura que cada operação tenha uma perda máxima controlada.

- **Indicadores Utilizados:**
  - Média Móvel de 200 períodos para análise de tendência.
  - Média Móvel de 50 períodos para confirmação de tendência.

- **Visualização no Gráfico:**
  - Desenha linhas horizontais representando os níveis críticos (mínima, 25%, 50%, 75% e máxima da vela semanal) para facilitar a análise e acompanhamento dos trades.

## Estratégia de Operação

1. **Divisão da Vela Semanal:**
   - A vela semanal anterior é analisada para identificar a mínima e a máxima.
   - A amplitude é dividida em 4 canais (25%, 50%, 75% e 100%), aproximando os níveis de Fibonacci.

2. **Critério de Entrada:**
   - **Compras:** Se uma vela M15 tem abertura abaixo e fechamento acima do nível de 50%, o robô compra, colocando o stop loss na base do nível rompido e take profit no próximo nível.
   - **Vendas:** Se uma vela M15 tem abertura acima e fechamento abaixo do nível de 50%, o robô vende, com stop loss no topo do nível rompido e take profit no próximo nível.

3. **Cálculo do Tamanho do Lote:**
   - O lote é ajustado dinamicamente de acordo com o risco definido pelo usuário e a distância do stop loss, controlando a perda máxima por operação.

## Configurações do Usuário

- **Risco em USD:**  
  Define o valor máximo de perda por operação.

- **Parâmetros das Médias Móveis:**  
  Permite a personalização dos períodos, tipos e preços aplicados para as médias móveis utilizadas na análise de tendência e confirmação.

- **Tamanho dos Canais:**  
  Os valores de 25%, 50% e 75% podem ser ajustados para adaptar a estratégia às condições do mercado.

## Como Funciona

1. **Inicialização (OnInit):**
   - Carrega os indicadores das médias móveis e os adiciona ao gráfico.
   - Configura o número mágico (magic) para identificação das operações.

2. **Execução (OnTick):**
   - Atualiza os dados dos indicadores e verifica se houve uma nova barra semanal para redesenhar os níveis críticos.
   - Analisa a vela de 15 minutos para identificar padrões de entrada.
   - Calcula o tamanho do lote com base no risco definido e executa as ordens de compra ou venda, se os critérios forem atendidos e não houver posições abertas.

3. **Cálculo do Lote:**
   - Realiza o ajuste do tamanho do lote conforme a distância entre a entrada e o stop loss, garantindo um risco controlado.

4. **Visualização:**
   - Traça linhas horizontais no gráfico para marcar os níveis de negociação (mínima, 25%, 50%, 75% e máxima da vela semanal).

## Como Executar

1. **Pré-requisitos:**
   - Plataforma MetaTrader 5 (MT5) com acesso ao MetaEditor.
   - Conhecimentos básicos em MQL para personalizações e ajustes.

2. **Instalação:**
   - Importe o código para o MetaEditor criando um novo Expert Advisor (EA).
   - Compile o código e corrija eventuais alertas ou erros.
   - Adicione o EA ao gráfico do ativo desejado no MT5.

3. **Configuração:**
   - Ajuste os parâmetros de risco, indicadores e tamanho dos canais conforme sua estratégia e perfil de investimento.

4. **Execução:**
   - Certifique-se de que o EA está habilitado para operar e que o gráfico possui os dados históricos necessários.
   - Monitore as operações e a visualização dos níveis traçados no gráfico.

## Riscos e Considerações Importantes

- **Estratégia Não Testada Extensivamente:**  
  Este robô é um exemplo educacional e não foi validado de forma abrangente. A estratégia não funciona a longo prazo, embora tenha periodos de lucros em alguns prazos, ao longo do tempo a soma das operações resultam em perdas financeiras.

- **Riscos Envolvidos:**  
  O trading automatizado envolve riscos significativos, incluindo perdas financeiras. Recomenda-se utilizar o robô em ambiente de demonstração antes de operar com capital real. Este robô é um exemplo educacional e não foi validado de forma abrangente. A estratégia não funciona a longo prazo, embora tenha periodos de lucros em alguns prazos, ao longo do tempo a soma das operações resultam em perdas financeiras.

- **Uso Educacional e Desenvolvimento Profissional:**  
  Este projeto é ideal para pessoas a se inspirarem e criarem suas estratégias, e também para programadores para ter uma ideia de como criar um robo.

## Contribuições

Contribuições, melhorias e sugestões são muito bem-vindas! Se você deseja colaborar, abra uma _issue_ ou envie um _pull request_.

## Licença

Este projeto é distribuído sob a [MIT License](LICENSE).

## Observações

Este exemplo foi desenvolvido com o intuito de auxiliar no aprendizado e experimentação de estratégias automatizadas. Ele não deve ser utilizado como única base para decisões financeiras.

---

*Este projeto é fornecido "no estado em que se encontra", sem garantias de qualquer tipo, expressas ou implícitas.*
