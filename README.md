
# 🎶 SongWritingStudio

## Contexto

Olá 👋

Este é um projeto idealizado, estruturado e codificado visando atender os requisitos para o case de aplicação solicitado:

    "Desenvolver uma nova aplicação simples de tema à seu critério ou parte de uma solução complexa porém funcional."


## Processo de idealização

O processo de idealização da aplicação se deu a partir da utilização de parte da metodologia CBL (Challenge Based Learning). Onde busquei levantar questionamentos acerca de possiveis aplicações em que eu me identificasse e que auxiliariam em alguma atividade do meu dia a dia. Após o processo de pesquisa e reflexão, decidi desenvolver uma aplicação visando auxiliar o processo de composição musical. 

## Funcionalidades

As funcionalidades planejadas para a aplicação visam auxiliar partes do fluxo de composição musical, sendo essas:

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

### Requisitos Fucionais

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


## Estruturação

Visando garantir uma melhor visualização da estrutura do sistema, construí um diagrama simples demonstrando as relações entre as entidades do projeto:
<img width="780" alt="Screenshot 2023-12-13 at 01 54 37" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/0e6c83c8-4549-4502-b7e1-421526877c62">

Dessa forma, a entidade de Disco é referênciada pelo DiscoProfile em uma relação one-to-one, onde esse possui uma relação one-to-many com as entidades de Album Reference e Section.
Sendo essas possuindo também suas respectivas relações com as entidades demonstradas na imagem.

## Decisões Estruturais

1. A decisão de desacoplar a referência direta da entidade Disco ao seu DiscoProfile correspondente se deu pensando em garantir uma maior velocidade de carregamento no momento da listagem
dos discos, tanto por conta da menor quantidade de banda solicitada, em casos de requisições remotas, quanto por quantidade de dados necessários.

2. Decidi utilizar Clean Architecture para organizar e arquitetar a comunicação entre as diferentes partes do sistema. Essa decisão e se deu pela facilidade da arquitetura em desacoplar e acoplar componentes de uma camada com responsabilidade específica sem interferir em outras camadas com outras responsabilidades. Essa facilidade foi definida como um requisito por mim para possibilitar a utilização de diferentes formas e tecnologias ou frameworks de realizar uma mesma ação. Como por exemplo URLSession e Alamofire para requisições de APIs. Além da utilização como show case para aspectos importantes no desenvolvimento de aplicações como testes unitários.

3. Para buscar e adicionar novas referências ao DiscoProfile decidi utilizar a API do [Spotify](https://developer.spotify.com/documentation/web-api "Spotify"). Por conta da documentação clara e bom uso do padrão REST. Essa, também se mostrou um bom show case para requisitos comuns em APIs como RefreshTokens.

### Use Cases

Diante disso, estabeleci Use Cases necessários para a aplicação atender os requisitos. Esses foram idealizados para que se tornassem a base solida da aplicação, ou seja, os componentes que menos se alteram. Por conta disso, toda a utilização do Use Case se dá a partir de fronteiras, implementadas em código por meio de protocolos. 

*Use Cases*

<img width="961" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/2f34854b-0e19-4800-afb5-13c51a864e7e">

Diante dos UseCases estabelecidos, estabeleci as fronteiras a serem implementadas pelos serviços da camada de dados da aplicação:

<img width="931" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/90018922-20e3-4f49-b953-3b7eca06a036">

O fluxo de implementação do serviço pode ser visto abaixo. A forma como o serviço de referencias está estruturado está de acordo com as necessidades referentes a API do Spotify, necessidade de autenticação, etc. Essas especificações da API foram tratadas como detalhes de implementação e não como regra de negócio do sistema. Por conta disso, o UseCase foi construido agnostico a necessidade de um RefreshToken ou não. 

Porém, perceba que independente da forma como o serviço se estrutura, ou de que forma ele utiliza a camada de infraestrutura para capturar os dados, o use case não é afetado, cumprindo o objetivo da abstração.

<img width="690" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/ca0ddb41-2c6f-4c1a-9624-c4196b1d9426">

## Apresentação dos dados

## Decisões
- Navegação vertical como detalhe
- VIP + Router (Navegação horizontal)


