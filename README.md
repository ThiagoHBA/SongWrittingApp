<img width="360" alt="image" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/be64c901-d44e-4996-a199-9679223be611">

# 🎶 SongWritingStudio

![Coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/ThiagoHBA/591fb2a8ad5a53abefc115f035d03162/raw/coverage_badge.json)

# 1 - Contexto

## Processo de idealização

O SongWrittingApp foi idealizado a partir de uma necessidade pessoal de organizar projetos e audios, no contexto de composição musical. Aplicativos como o Voice Memos, nativo do iPhone, são ótimos para armazenar as gravações porém não permitem uma separação clara das seções do áudio, por serem idealizados para serem utilizados como aplicativos de gravação generalistas. O SongWrittingApp busca trazer uma solução especializada para o contexto de compositores/bandas que gostariam de obter uma melhor organização dos seus projetos, separando por seção e agrupando referências.

Atualmente, as principais funcionalidades do aplicativo são:

- Iniciar um projeto de composição (Disco)
- Buscar referências para o projeto
- Gravar o áudio dos instrumentos
- Organizar os audios em seções dentro da música (Introdução, Verso, Refrão, etc.)
- Reproduzir todos os audios das seções em sequência

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
- Remover gravações nas 
- Reproduzir o áudio das seções


# 2 - Estruturação da aplicação

> Os demais artefatos relacionados a estruturação da aplicação vão ser disponibilizados na seção final!

Estrutura atual do repositório:

- `Sources/App`: composição da aplicação e ciclo de vida
- `Sources/Core`: networking, persistência e componentes compartilhados
- `Sources/Features`: implementação das features
- `Main`: recursos do app, `Info.plist` e `LaunchScreen`
- `UnitTests` e `UITests`: suítes de teste ativas

<img width="780" alt="Screenshot 2023-12-13 at 01 54 37" src="https://github.com/ThiagoHBA/SongWrittingApp/assets/56696275/0e6c83c8-4549-4502-b7e1-421526877c62">

A entidade de Disco é referênciada pelo DiscoProfile em uma relação one-to-one, onde esse possui uma relação one-to-many com as entidades de Album Reference e Section.
Sendo essas possuindo também suas respectivas relações com as entidades demonstradas na imagem.

## Decisões Estruturais

### Arquitetura e organização

1. A aplicação foi estruturada seguindo princípios de Clean Architecture, separando regras de negócio, apresentação, dados e infraestrutura. Os Use Cases são expostos por protocolos e representam as fronteiras que permitem que frameworks como CoreData, URLSession, Keychain, UserDefaults e FileManager sejam substituídos/testados por meio de abstrações. Essa decisão também foi tomada buscando testes unitários focados em comportamento, pois Interactors, Presenters, Repositories, etc, podem ser exercitados sem depender diretamente de frameworks do sistema.

2. A implementação foi consolidada em uma única árvore principal em `Sources`, mantendo a separação por responsabilidade: em `App`, `Core` e `Features`. 

   - `Sources/App` concentra ciclo de vida, composição e injeção de dependências
   - `Sources/Core` concentra infraestrutura compartilhada, persistência, networking e design system
   - `Sources/Features` concentra os fluxos de produto organizados por domínio
   -  O diretório `Main` ficou responsável por recursos do aplicativo, como `Info.plist`, assets e `LaunchScreen`.
  
3. A decisão de desacoplar a referência direta da entidade Disco ao seu DiscoProfile se deu pensando em garantir maior velocidade de carregamento no momento da listagem dos discos. A listagem trabalha com uma entidade resumida (`DiscoSummary`) e carrega apenas os dados necessários para apresentação da lista, enquanto informações mais detalhadas, como seções, gravações e referências, ficam concentradas no profile. Essa separação reduz o volume de "banda" necessária, possibilitando uma maior velocidade no carregamento dos dados.


### Composition Root

4. A composição da aplicação foi centralizada em Containers e Composers (ou Factories). O `AppContainer` define as dependências globais da aplicação, enquanto containers específicos, como `DiscoListContainer`, `DiscoProfileContainer` e `OnboardingContainer`, montam os objetos necessários para cada feature. Isso foi feito buscando uma "modularização", de forma que a adição de novas funcionalidades no sistema seja facilitada. Os Composers conectam ViewController, Interactor, Presenter e Router. Essa abordagem reduz acoplamento, torna a inicialização mais explícita e facilita a criação de testes.

5. Para a camada de apresentação foi utilizado o padrão VIP associado a Router. O ViewController fica responsável por renderizar estado e capturar ações do usuário enquanto o Interactor coordena os Use Cases baseado nas interações do usuário (Recebidas pelo ViewController). Após isso, o Presenter transforma respostas de domínio (vindas do interactor) em View Entities. O Router concentra navegações horizontais. Navegações verticais, como sheets e modais locais, foram tratadas como detalhes da UI quando não representam mudança real de fluxo.

8. A composição utiliza proxies: O `WeakReferenceProxy` evita que Presenter mantenha a View viva indevidamente, enquanto o `MainQueueProxy` garante que chamadas de apresentação sejam entregues na main thread. Essa decisão mantém os Presenters simples e evita espalhar `DispatchQueue.main.async` pela lógica de apresentação.

### Infraestrutura

6.  A comunicação com infraestrutura foi "protegida" por interfaces próprias. O networking usa `Endpoint` e `NetworkClient`, a persistência usa `DiscoStore`, o Keychain usa `SecureClient`, o armazenamento de arquivos usa `FileManagerService` e o onboarding usa `UserDefaultsClient`. Além disso, existem implementações concretas como CoreData e stores em memória. Essa escolha permite alternar implementação sem alterar as features e torna possível testar fluxos com doubles.

7. A busca de referências foi modelada com o uso do Design Pattern Strategy. O `ReferenceSearchStrategyRegistry` seleciona a implementação correta de acordo com o provedor escolhido, hoje contemplando Spotify e LastFM. A autorização do Spotify foi encapsulada em um Decorator (`AuthorizationDecorator`), responsável por adicionar o header de autorização e tentar novamente a requisição quando o token cacheado deixa de ser válido. Dessa forma, autenticação e escolha de provedor ficam fora do Use Case de busca, que permanece agnóstico ao detalhe de cada API.

### Design System

9. O projeto também possui uma estrutura própria de Design System, separando tokens, considere "SW" como uma abeviação para "SongWritting", (`SWColor`, `SWSpacing`, `SWTypography`, `SWRadius`, `SWSize`) e componentes reutilizáveis em Atoms, Molecules e Organisms. Essa organização dá consistência visual e reduz duplicação de estilo e facilita ajustes globais de UI. Dentro dessa camada também existem tratativas de acessibilidade, como labels, identifiers e suporte a Dynamic Type.

### Testes

10. Para reduzir boilerplate nos testes, o projeto utiliza um pacote de macros Swift (`SongWrittingAppMacros`), criado especificamente para esse projeto, para gerar spies e rastrear chamadas de métodos com anotações como `@SWSpy` e `@SWSpyMethodTracker`.

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

# 4 Artefatos

1. [Diagramas](https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=SongWrittingApp.drawio#R7V1rd5s4Gv41OWf3Q3oQdz4mdqftbtrtJu3OzH5TbMVmiq0s4CTur19hLjbSS4IDSHLKmc5JwODA87x675LOrMnq6UOM75ef6ZxEZ6YxfzqzpmemafnIZT%2ByM9vijGva%2BZlFHM7zc2h%2F4ib8SYqTRnF2E85JUrswpTRKw%2Fv6yRldr8ksrZ3DcUwf65fd0aj%2BV%2B%2FxgggnbmY4Es%2F%2BHs7TZX7Wd4z9%2BY8kXCzLv4yM4pMVLi8uTiRLPKePB6es92fWJKY0zX9bPU1IlKFX4pLf91vDp9WDxWSdtrnhj%2FjD1%2F9e%2F%2BP9X7dk%2Bhl%2Fwffb2%2Bm5XTzcA442xRufmW7EvvByHj5kT51uCyjc%2F22yR72s%2FbYofu7uuI35M%2Bxpdl9TnjVr32jGdLOek%2Bz5EPv4cRmm5OYez7JPH5k8sXPLdBUVH%2BMoXKzZ73GO9iWOZ4W4IL%2F68gcSp%2BSpESFU4c4kltAVSeMtu6S8wS%2FQ2PJkPu6pR75bnFwe8G6XV%2BJC3hbVt%2B8pYb8UrMAMOfbPm9D8%2FWn69O%2Fz7X9%2B%2BL%2Fh4Md54AIMdcGxARUAu0agTNusI3WOXAApOwCQsoKhkDID%2FZBCiAPKtSCgfEikrB6AAge9jwYBqt%2BxZwQiUB449JzBBMrSUKCEkWcDAuV6ckfeG7Mi3Rhy6gxZAEF7LuQYkfKRDlAjc%2BbnFIc0Tpd0Qdc4er8%2Fe7nH1WBH%2B2uuKL0v0PyLpOm2wA9vUlrHmmEYb%2F%2FI7n%2FnlId%2FFl%2B3O5g%2B1Y62xVEjCQndxDPynCDm16U4XpD0OTzy6zIMnqU0JhFOw4e6L9g%2FO7ZO7CDl7CBTK3pMQbldkzvCXn9GkhsSP4TspZt1kiHHIwucuvmErAJkFNyhVI77a8i0fZIax2%2Fh2Uiga3jYLaQV7rYA%2BxXF8706%2BZ6QCU7UqxPLqPswbuC9cwA3U6ZCcQTsvsY0pTMagZ4jXmWwROIRoLyLj%2Bu3vuRsqmHCMk3lTCCt%2FJXhvEn%2FNP0VXxgo36%2BvbkiShHQ9icIMBuVSzUextg0ItSlVqEU373X65WOa3pcw66xYWqXwpFJQvcSegild4XAtgMXeMQMxSWP6g0xoRGN2fk3XmaK5C6OIO3WA3B1dp4WKMe3yuPji7PMMwHCGo4siT7AK5%2FOd%2FioTBzMGOYn7yqNy6UHXBzgwwFTBUByI2mOKU%2FxWGUAul60xoZS%2FVAYsMZn2aX0Xv10KbI6Cc9NRzoGoiV5nDED3%2Fl%2Bb9H6jt3VAnNvpA8PClGocLLG680%2BynSwh8yAbLcevZ180cGc8S0DlTfroTtukoqdXJsDTKoYaLj%2FWmp9yfGvCT%2FncB%2BrmYsPwjsOf7K%2FT9Ue8ZiYxVq963DZuvNTMryNman7haqDP%2B5cmwI9jAQQ5aDCGxJ6Sz284zNrDW5Jge6o9zHL0vXn977XU%2F45m%2Bt8Thoh%2BVT%2Fb4OUaUi5Sc8Pur%2BLXBC3l2jW1kmvPV8GPDJz18u8dMVyt%2BY9TMqMxTql6D9Lyq9peqUYsBKiRMsY9VCPeYGpETMDop35NLoUOJw9tqWE%2F5Huf0ngv1eXL412vjgqvRfPx2wBeM0etfG7dA3W%2B1KOBsnBFZXFDZpuYNFSJXwCpjmgPkLm8ewtCJjetCrXON6f%2FYUnUOO%2FPp5NAxKVmkwIkgCIjoHgK0zyeMJ3i8M%2BDj%2FbhRHbQQ6eJ0VL5lm3j8pUvOJPEUmLk9tFercawD%2F0aor09qYecGi045eAemGRfbfuQWH%2BexASn5At5nIbJjOrSpFhNcnm%2BSVGqtgKmVr2ucLxD%2BhQaFJHNmQwweJSagyojVS200mAZKL9tD3Qpk5o47L6SDNRrM4QNjkAbozEsqa5WjgAytOo3aM%2Bqp8YVAGhuwNVUOlbFCQt1w6Ta%2BBhc5w3UPynXAQBKq2SVtVDe6uAzBa52nUqB6G%2B%2BzmUCvdQT6LXjHSj1vXaBmFPbYSpAlTyGqwjn%2FQAHFf4Mt9kyjOZXeEs32dMmKZ79KI8udzkRdj0uUWQfx1W%2FgHsGdxdUN91kX1b8mZgk7LavJf6IO%2FUZP9UuvMJJWj4gjSJ8n4S3VVPCimnjcH1J05SupLFv2lyHyDmCHGgoMYgMeygBgMoIl8VdF%2Bzn9%2B%2BfpoI0HNkuUrZ6ROQuu41vCUkzH%2BAyYdiH68XV7pqpvT9zXeCQnaLs3rtot7jOMpzPyXrnW6SZ0q3k8Z6G63SHk3PJ%2FjE4J5nT4LAHn7BjtD9m%2F7LL43RC1%2BxdcLjjljDJeSSZ9BwvFM8PspdFpUzGue3koryuf7GApo1mYrHGK5ILxk0aM3JG0ZAsGmW7ojrRED3FXDRmGQOfVrtltjIB6WM2ySgeR4pH2fWhTjzEdqr36zRk%2F5GkqzTo2nYoWHYks%2BsQDieVFFPOXhU4wy9w1i5udmBmJCVDYO%2BZRTVMesUYcHSiwXF1zOphpsvPwIGcaNMAWph6caJBMRCDqNwiznehVG4MwahqtIbt5aJ5AB7jRoOS0YcxhKumDYIRVx1uuXQwOKumtx3Ao5zIlBPAp5YrJ00udUJmWT9JJSQ3xfEoIrJFBPCr5YoI2MG1E4bRyxjeywCm2oH0l2LSO%2F3Q2sB5mo69UngXZqHMmJUZTjs0hBm6OBpILK2UnsaMxvNDNyM7Hg2IdBFR7mMEAuMyy%2FbVQbsGvrP%2BEgmFD%2F5yw6UF8ycnkwDMIlLBV4%2B4l8tsvZzBcVUCD6wGVujI0a%2Fq368KuPnZyv0q1BSip3iRG81PmRnZrNgbfsOjY9V%2F2GVq7lk1xeZ4Mw%2BL5N7366tRMCQLhnJ%2FCrXYrkXjKRI9Wnq3paFHSj0sJBYmL6LbzWqfeB0N%2FgAG327R8wSXawbbFQeJK1%2BOzS2SlLqnubWHwrCdtWfUZdCMwqFMOJRbfHDzozzJFjF8yBSno%2FpQKSHKizRu2964UUCUCEjVAqJOh6iZ5K4%2BSADSsM9YYFVBgqnHqjodFiXohazyrV9kK9%2FjVxVbttqaBjeYPH1WJWhNqtpVCZ59zIMh%2BIGkh32VPS5L0Cm4DRyuSUDusgTPDMge5tjBmMuZZNeJFS%2BoZxykTrKDTZ%2BYeVKht%2FpUJW1TfpbS2t4pbrc5GD86qnoxhX4xn38hj1VO9hvteyGabntX23z9ElT5ktXLm2sdKEF%2BWb34StWL4pW9j1Euin1PiFENFRKwI9OURCQlemkhs92mnVIdT0vU5a9zPJ%2B1ACfgfyILtXBAfanciAWvV65VJgyGUyDEsHWLCGxo8TiSsBfCYEu%2FPvNkuzHhc7EZsqHdy6VOlLWhlP1Je0922%2BSdrbbjVU1mFWxI1tx7ghjV0HsqH1MI54qZSroFc56pXzBni%2F2oXdwoEPlTsNmtsnhSnSgb6ho6bUPhtDUUDVVVSYZC7YKTR85c6bCM6GCk6mgrxEJrGfhlky%2B%2B0WIbe12MhckHEccYi%2BrK%2FmEUSwvdom4I%2FBOwF%2FtuUW3sBbA55vNTScZ2485iYCHObWg7vwg5g83bb5q5vdiEjChBCsYWsK7TcDWfqu2KOeZcIB4oI26UB8nyoLyrGNgAr1g9ipmKzkvmjfJwpDyo7yEWsyi5PNziZBQH2eKgvmPYbZqhPNskzLf6W95K%2FvdRMmRLhtXStxxMMjy1GXSuvWmfChl%2BwmnbxJWnNMfhvbnSUnvglZaW1Gx93XmLGhXpQohRMF2otNG%2F3HP3NAhVQU%2Be2lLFD7C%2F7K7gdBUm6aesfwDPetoAvVN6yLFMbgN0hIAM0WB72MGyrXgPu3e2W5fudwYK2qqsI%2Brhu2%2F4SuKQwZY1lPQ%2BVLzTsE2uTqpMptPWlh9X6QxAzxv5eYEfpU3XrljxqkxN0UPXzx7w3QoRDtfoZgaq7YzbWxNoCfc13aTD73LerS7IlQWRA21zLpcHcbpGRx7YL%2FcR3l7RRTjTmg2b25NQAzY8qBO3ExuXmyRckyS53kSD7%2BfcbaKk0WZsSJ1E4PXV%2FcabhF1btf4DRFBXYHgSyKTEN5vtrYBXkXM%2BAOXY9HPVbt7YmA6xUOepByJ8mycCGBuQohps0TIfKgM0iiuSIq4B385vALvyepC42s5gODVsZNy0J9ObEVnk8puQQUvtyZXZXzWW8tvmyX2l8%2BP9X3VN%2BPb8KI11A9XjxzassyMS38dXMoZOCrYmOremyohWU7BS3Krud927sbj1a9ZMcGAILS6w8Rxu9fhcGorbOOqq5%2BjApupqle%2B6tWH7zkDeS0NXm4GodjeIUnRUjUTvTY1Ej0uDenyYOvBIRAZSQud%2BKJqvagVA6oSgzXQwpXvu%2Bg215iLA06jcjByHrzZD%2B0JbUtM50HSEF%2FJoBbInk9hEDjexF9lA9cWElhkYDndo9mg73E8rhYmQkIYAhN5EMsEPVFsBVe1DpdjrHudqtU6fxDxRa37Ubk4XKOlZUYKz2jQAsPyYaAg0aG9AJm9hLSDXLNezyanrq3ZYQH4ypXVk8mYX9Hnkmt1eq7kFIyfQdLIvFj7Hhdw%2BB2SIw2NC42zPEpz9f6vDIguoev9yt6iqTngIXE8L8rDDmNL0MOPAXmr5mc5JdsX%2FAQ%3D%3D)
2. [Linkedin](https://www.linkedin.com/in/thiago-batista-ios-engineer/)
3. [E-mail](https://mail.google.com/mail/u/0/?fs=1&to=thiago.dev.engineer@gmail.com&su&body&bcc&&tf=cm)
