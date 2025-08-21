# PureDownloader

PureDownloader é um aplicativo leve, rápido e sem anúncios que permite baixar vídeos e áudios de sites como youtube, twitter, entre outros, diretamente do seu dispositivo. Ele funciona como um wrapper para o [yt-dlp](https://github.com/yt-dlp/yt-dlp), oferecendo toda a potência dessa ferramenta, mas com a conveniência de rodar localmente, sem depender de servidores externos.

## Funcionamento

O app realmente age como um wrapper para o yt-dlp, utilizando Flutter para a criação das interfaces gráficas, utilizo do MethodChannel para chamadas nativas ao android, que por sua vez, usando o [chaquopy](https://github.com/chaquo/chaquopy) faz chamadas a um script python que utiliza o nosso querido yt-dlp.

*Flutter v3.27.4*