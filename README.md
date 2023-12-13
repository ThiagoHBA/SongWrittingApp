<img width="360" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/be64c901-d44e-4996-a199-9679223be611">

# 🎶 SongWritingStudio

# 1 - Contexto

Olá 👋

Este é um projeto idealizado, estruturado e codificado visando atender os requisitos para o case de aplicação solicitado:

    "Desenvolver uma nova aplicação simples de tema à seu critério ou parte de uma solução complexa porém funcional."


## Processo de idealização

O processo de idealização da aplicação se deu a partir da utilização de parte da metodologia CBL (Challenge Based Learning). Onde busquei levantar questionamentos acerca de possiveis aplicações em que eu me identificasse e que auxiliariam em alguma atividade do meu dia a dia. Após o processo de pesquisa e reflexão, decidi desenvolver uma aplicação visando auxiliar o processo de composição musical. 

Devido a isso, as funcionalidades planejadas para a aplicação visam auxiliar partes do fluxo de composição musical, sendo essas:

- Iniciar um projeto de composição
- Buscar referências para o projeto
- Gravar o áudio dos instrumentos
- Organizar os audios em seções dentro da música (Introdução, Verso, Refrão, etc.)

### Linguagem Ubiqua
    Disco: Projeto de composição.
    Profile: Detalhes do projeto de composição.
    Album Reference: Albums de refererência a composição.
    Section: Seções de composição do disco.
    Record: Gravações enviadas ao aplicativo.

### Requisitos Funcionais

- Criar disco 
- Consultar todos os discos
- Excluir disco
- Consultar profile do disco
- Adicionar novas referências ao profile
- Listar referências adicionadas ao profile
- Remover referências adicionadas ao profile
- Adicionar novas seções ao profile
- Listar seções adicionadas ao profile
- Remover seções adicionadas ao profile
- Organizar as seções adicionadas
- Adicionar gravações em seções específicas do profile
- Remover gravações nas seções


# 2 - Estruturação da aplicação

> Os demais artefatos relacionados a estruturação da aplicação vão ser disponibilizados na seção final!

Visando garantir uma melhor visualização da estrutura do sistema, construí um diagrama simples demonstrando as relações entre as entidades do projeto:


<img width="780" alt="Screenshot 2023-12-13 at 01 54 37" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/0e6c83c8-4549-4502-b7e1-421526877c62">

Dessa forma, a entidade de Disco é referênciada pelo DiscoProfile em uma relação one-to-one, onde esse possui uma relação one-to-many com as entidades de Album Reference e Section.
Sendo essas possuindo também suas respectivas relações com as entidades demonstradas na imagem.

## Decisões Estruturais

1. A decisão de desacoplar a referência direta da entidade Disco ao seu DiscoProfile correspondente se deu pensando em garantir uma maior velocidade de carregamento no momento da listagem
dos discos, tanto por conta da menor quantidade de banda solicitada, em casos de requisições remotas, quanto por quantidade de dados necessários.

2. Decidi utilizar Clean Architecture para organizar e arquitetar a comunicação entre as diferentes partes do sistema. Essa decisão e se deu pela facilidade da arquitetura em desacoplar e reusar componentes de uma camada com responsabilidade específica sem interferir em outras camadas com outras responsabilidades. Essa facilidade foi definida como um requisito por mim para explorar as diferentes formas que uma tecnologia ou framework pode realizar uma mesma ação. Como por exemplo URLSession e Alamofire para requisições de APIs. Além da utilização como show case para aspectos importantes no desenvolvimento de aplicações como testes unitários.

3. Dividi a aplicação em diferentes targets respeitando as camadas que estabeleci, Domain, Data, Infra, Presentation, UI e Main. Essa divisão em targets foi pensada tanto por conta de permitir um auxilio na integridade da arquitetura por meio do compilador, quanto por conta do aumento na velocidade de execução de testes, builds, etc. 

4. Para buscar e adicionar novas referências ao DiscoProfile decidi utilizar a API do [Spotify](https://developer.spotify.com/documentation/web-api/reference/). Por conta da documentação clara e bom uso do padrão REST. Ela também se mostrou um bom show case para requisitos comuns em APIs como RefreshTokens.

### Use Cases

Diante disso, estabeleci Use Cases necessários para a aplicação atender os requisitos. Esses foram idealizados para que se tornassem a base sólida da aplicação, ou seja, os principalmente os componentes que menos se alteram. Por conta disso, toda a utilização do Use Case se dá a partir de fronteiras, implementadas em código por meio de protocolos. 

*Use Cases*

<img width="961" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/2f34854b-0e19-4800-afb5-13c51a864e7e">

Diante dos UseCases estabelecidos, estabeleci as fronteiras a serem implementadas pelos serviços da camada de dados da aplicação:

<img width="931" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/90018922-20e3-4f49-b953-3b7eca06a036">

O fluxo de implementação do serviço pode ser visto abaixo. A forma como o serviço de referencias está estruturado está de acordo com as necessidades referentes a API do Spotify, necessidade de autenticação, etc. Essas especificações da API foram tratadas como detalhes de implementação e não como regra de negócio do sistema. Por conta disso, o UseCase foi construido agnostico a necessidade de um RefreshToken ou não. 

Porém, perceba que independente da forma como o serviço se estrutura, ou de que forma ele utiliza a camada de infraestrutura para capturar os dados, o use case não é afetado, cumprindo o objetivo da abstração.

<img width="690" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/ca0ddb41-2c6f-4c1a-9624-c4196b1d9426">

## Apresentação dos dados

A camada de apresentação dos dados foi estabelecida por mim como a camada que vai lidar com respostas as interações do usuário e organizar os resultados a partir da utilização dos UseCases.

## Decisões

1. Como Design Pattern para organizar a camada de apresentação eu utilizei o VIP (View, Interactor, Presenter). Levando em consideração que o usuário possui diversas interações e inputs de dados, como no momento da criação do disco, na adição de referências, seções, etc. O VIP se mostrou como uma solução viável devido a separação entre componentes para lidar as interações (Interactor) e com os resultados (Presenter), ao invés de outros patterns comuns, como MVP, MVC e MVVM que muitas vezes centralizam essa responsabilidade. Dessa forma, as camadas podem ficar melhor separadas e com responsabilidades mais específicas.
   
2. Para lidar com a navegação e envio de dados entre uma tela e outra, utilizei o padrão Router, comumente integrado ao VIP. Dessa forma, pude garantir que a navegação fosse arquitetada pela lógica de apresentação (Presenter) sem necessitar que a camada adicionasse dependencias como UIKit.
  
3. Atribui navegações verticais, como ModalSheet, como detalhes de implementação da camada de UI, dessa forma, deixando a responsabilidade do Router apenas das navegações horizontais. Essa decisão se deu por conta das diferentes formas de implementar a UI, visando blindar a camada de apresentação de mudanças toda vez que novas alterações fossem realizadas na UI.

# 3 - O que eu adicionaria

Por conta do tempo existiram algumas implementações que foram levantados como requisitos não funcionais por mim mas que não foram possíveis serem feitas ou que foram realizadas de forma incompleta.

1. Os testes unitários foram realizados a partir da proximidade da camada com as regras de negócio, logo, por conta do tempo, as camadas mais distantes da regra de negócio em si, como UI e Infra infelizmente não puderam ser cobertas por testes, apesarem de estarem prontas para isso. Porém, é possível encontrar os testes em sua completude para as features da aplicação na camada de apresentação e camada de dados.

2. Gostaria de adicionar testes unitários a framewoks padrões do sistema como CoreData ou URLSession. Isso não foi possível de ser explorado por conta do conflito entre finalizar detalhes da UI e atualizar os testes diante do tempo disponível. Porém, vou deixar um exemplo de [Código](https://github.com/ThiagoHBA/clean_arch_cloudkit_client/blob/develop/cloudkit-clientTests/Data/DAO/Task/TaskDAOTest.swift "Código") em que realizei os testes do framework CloudKit para exemplificar de que forma eu faria os testes.

2. Alguns UseCases essencias para aplicação não foram possíveis de serem implementados por conta do tempo, como: os UseCases de Deleção de discos, deleção de seções e deleção de referências. Esses UseCases são importantes para a utilização do aplicativo e completude da aplicação acomo um todo.
  
3. Eu gostaria de ter explorado mais blibliotecas de terceiros comumente utilizadas em ambientes de desenvolvimento iOS, como Kingfisher para o carreamento das imagens e Alamofire para realizar requisições além do URLSession. Porém, como considerei isso um extra, foquei em implementar outras partes do sistema consideradas mais urgentes.
  
4. Gostaria de ter implementado também um exemplo de utilização de plataformas de métricas como Firebase Crashlytics, MixPanel, Amplitude, etc. Acredito que essa implementação demonstra bem a utilização e o potêncial da injeção de dependências no contexto do desenvolvimento.

5. Gostaria de ter utilizado rotinas de CI com code coverage para execução dos testes nos targets, por meio do Fastlane ou GitHub Actions, como fiz nesse [outro projeto](https://github.com/ThiagoHBA/clean_arch_cloudkit_client/actions).

6. Não consegui localizar as Strings utilizadas no sistema pelos Targets como implementei [nesse projeto](https://github.com/clio-app/clio-ios-app). Isso também foi considerado como um extra por mim, portanto, foquei na implementação de outras partes do sistema. 

7. Gostaria de ter explorado mais aspectos de acessibilidade como VoiceOver, Dynamic Text e Reduce Motion. Como implementado [nesse projeto](https://github.com/bubble-jam-organization/bubble-jam)

8. Gostaria de ter implementado paginação para as requisições da API do spotify para possibilitar com que fosse possível o carregamento de novas informações ao final do scroll da página, como implementei [nesse projeto](https://github.com/clio-app/clio-ios-app/blob/dev/clio-app/Source/Presentation/SingleDevice/SearchImage/SearchImageView.swift) com requisitos parecidos (Em um contexto de busca por informações).

# 4 Considerações Finais

O iFood é uma empresa que eu admiro muito tanto em aspectos relacionados a cultura quando com o compromisso com a qualidade e estrutura do código. Já acompanho a parte ténica da organização há algum tempo a partir de eventos como Cocoaheads e artigos publicados por membros da empresa e acredito que fazer parte da equipe técnica da empresa seria um dos pontos mais altos no momento atual da minha carreira. Gostaria de agradecer de antemão pela possibilidade de fazer parte do processo e espero que possamos conversar em uma reunião para discutir aspectos relacionados a profundidade ténica. Obrigado!


