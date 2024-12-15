uses crt;

const
  MAX_PANJANG = 100;
  BATAS_X = 55;
  BATAS_Y = 25;
  SPEED = 200;
  MAX_PLAYERS = 10;

type
  TTempat = record
    x, y: integer;
  end;

  TPlayer = record
    name: string[20];
    score: integer;
    color: byte;  // Menambahkan field untuk warna pemain
  end;

var
  ekor: array[1..MAX_PANJANG] of TTempat;
  ujung, makanan: TTempat;
  players: array[1..MAX_PLAYERS] of TPlayer;
  playerCount, currentPlayerIndex: integer;
  arah: char;
  panjang, kecepatan, score: integer;
  mati: boolean;
  i: integer; // Variabel loop dideklarasikan di awal

// Prosedur untuk mengatur leaderboard
procedure TampilkanLeaderboard;
var
  temp: TPlayer;
  j, k: integer;
begin
  clrscr;
  // Sorting berdasarkan skor tertinggi
  for j := 1 to playerCount - 1 do
    for k := j + 1 to playerCount do
      if players[j].score < players[k].score then
      begin
        temp := players[j];
        players[j] := players[k];
        players[k] := temp;
      end;

  // Menampilkan leaderboard
  writeln('Leaderboard');
  writeln('=========================');
  for j := 1 to playerCount do
  begin
    TextColor(players[j].color); // Set warna sesuai pemain
    writeln(j, '. ', players[j].name, ': ', players[j].score, ' points');
  end;
  TextColor(White);
  writeln('=========================');
end;

// Mengatur posisi ekor ular
procedure AturPosisi;
begin
  ujung := ekor[panjang];
  for i := panjang downto 2 do
    ekor[i] := ekor[i - 1];

  // Menampilkan kepala, badan, dan ekor dengan warna pemain
  TextColor(players[currentPlayerIndex].color); // Warna sesuai pemain
  gotoxy(ekor[2].x, ekor[2].y); write('@');  // Kepala
  gotoxy(ekor[3].x, ekor[3].y); write('=');  // Badan
  gotoxy(ekor[panjang - 1].x, ekor[panjang - 1].y); write('-');  // Ekor
  gotoxy(ujung.x, ujung.y); write(' ');  // Hapus posisi ujung

  // Cek tabrakan dengan tubuh sendiri
  for i := 3 to panjang do
    if (ekor[2].x = ekor[i].x) and (ekor[2].y = ekor[i].y) then
      mati := true;

  delay(SPEED - kecepatan);
end;

// Menangani aksi makan makanan
procedure Makan;
var
  beda: boolean;
begin
  repeat
    beda := true;
    makanan.x := random(BATAS_X - 2) + 2;
    makanan.y := random(BATAS_Y - 2) + 2;

    for i := 1 to panjang do
      if (makanan.x = ekor[i].x) and (makanan.y = ekor[i].y) then
        beda := false;
  until beda;

  gotoxy(makanan.x, makanan.y); write('O');
  inc(panjang);
  inc(kecepatan, 10);
  inc(score, 5); // Tambahkan score
  gotoxy(BATAS_X + 2, 2); write('Score: ', score); // Tampilkan score
end;

// Menangani gerakan ular
procedure Bergerak(arahBaru: char);
var
  dx, dy: integer;
begin
  dx := 0;
  dy := 0;

  case arahBaru of
    'w': dy := -1;
    's': dy := 1;
    'a': dx := -1;
    'd': dx := 1;
  end;

  repeat
    // Cek apakah makan
    if (ekor[1].x = makanan.x) and (ekor[1].y = makanan.y) then
      Makan;

    // Gerakkan kepala
    ekor[1].x := ekor[1].x + dx;
    ekor[1].y := ekor[1].y + dy;

    AturPosisi;

    // Cek tabrakan dengan dinding
    if (ekor[1].x = BATAS_X) or (ekor[1].y = BATAS_Y) or 
       (ekor[1].x = 1) or (ekor[1].y = 1) then
      mati := true;

  until keypressed or mati;

  if not mati then
    arah := readkey;
end;

// Menampilkan batas permainan
procedure TampilkanBatas;
begin
  clrscr;
  for i := 1 to BATAS_X do begin
    gotoxy(i, 1); write('=');
    gotoxy(i, BATAS_Y); write('=');
  end;
  for i := 2 to BATAS_Y - 1 do begin
    gotoxy(1, i); write('|');
    gotoxy(BATAS_X, i); write('|');
  end;
  TextColor(players[currentPlayerIndex].color); // Set warna sesuai pemain
  gotoxy(BATAS_X + 2, 2); write('Score: ', score); // Tampilkan score di awal
end;

// Inisialisasi permainan
procedure Inisialisasi;
begin
  arah := 'd';
  mati := false;
  randomize;
  panjang := 10;
  kecepatan := 0;
  score := 0; // Inisialisasi score awal

  makanan.x := random(BATAS_X - 2) + 2;
  makanan.y := random(BATAS_Y - 2) + 2;

  ekor[1].x := 40;
  ekor[1].y := 3;

  for i := 2 to panjang do begin
    ekor[i].x := ekor[i - 1].x;
    ekor[i].y := 3;
  end;
end;

begin
  playerCount := 0;

  // Definisikan warna pemain
  players[1].color := 14; // Kuning
  players[2].color := 10; // Hijau
  players[3].color := 9;  // Biru
  players[4].color := 12; // Merah
  players[5].color := 8;  // Abu-abu
  players[6].color := 11; // Biru muda
  players[7].color := 13; // Magenta
  players[8].color := 4;  // coklat
  players[9].color := 6; // Emas
  players[10].color := 5; // Ungu
  

  repeat
    clrscr;
    TextColor(White);
    writeln('=========================');
    writeln('========Game Ular========');
    writeln('=========================');
    write('Masukkan nama pemain : ');
    inc(playerCount);
    readln(players[playerCount].name);

    currentPlayerIndex := playerCount; // Set pemain yang sedang bermain
    Inisialisasi;
    TampilkanBatas;

    for i := 1 to panjang do begin
      TextColor(players[currentPlayerIndex].color); // Warna sesuai pemain
      gotoxy(ekor[i].x, ekor[i].y); write('-');
    end;
    gotoxy(makanan.x, makanan.y); write('O');

    repeat
      if (arah in ['w', 'a', 's', 'd']) then
        Bergerak(arah)
      else begin
        gotoxy(20, 11); write('..Paused Game..');
        gotoxy(20, 13); write('Press w, a, s, d');
        repeat
          if keypressed then begin
            arah := readkey;
            if arah in ['w', 'a', 's', 'd'] then begin
              // Hapus pesan pause
              gotoxy(20, 11); write('                ');
              gotoxy(20, 13); write('                        ');
              break;
            end;
          end;
        until false;
      end;
    until (arah = #27) or mati;

    players[currentPlayerIndex].score := score;
    TextColor(White); // Kembalikan warna ke putih untuk teks akhir
    gotoxy(20, 10); write('Game Over! NT NT NT!');
    gotoxy(BATAS_X + 2, 4); write('Final Score: ', score); // Tampilkan score akhir
    readln;

    // Tampilkan leaderboard
    TampilkanLeaderboard;

    TextColor(White);
    writeln('Play again? (y/n): ');
  until readkey <> 'y';

  TextColor(White);
  writeln('Terima kasih:>');
end.
