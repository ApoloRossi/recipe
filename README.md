# Quero Receitas!

Projeto final para a disciplina `Mobile Engineering`


## Objetivo

Desenvolver um App em Flutter utilizando as melhores práticas a para avaliação final da disciplina Mobile Engineering


### Estrutura criada

- [Flutter](https://docs.flutter.dev/get-started/install)
- [sqflite 2.0](https://pub.dev/packages/sqflite)

### API Externa

- [OpenAI](https://beta.openai.com/examples)

### Rodar o projeto

1. Clonar o projeto

```bash
$ mkdir ~/projects
$ cd ~/projects
$ git clone https://github.com/ApoloRossi/recipe.git
```

2. Rodar o projeto
```bash
$ cd ~/projects/recipe
$ flutter run
```

### Descrição do projeto

Foi desenvolvido um App de receitas utilizando o Flutter com persistência no sqflite
para guardar os ingredientes que o usuário possui.
Após a escolha dos ingredientes o usuário vai confirmar e enviar para o
`openAI` o qual vai processar e devolver uma receita para o usuário fazer com os ingredientes
que escolhidos.