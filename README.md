# kumpulan-lirik-lagu-kebangsaan
Kumpulan lirik lagu kebangsaan

# Command To Deploy
flutter build apk --build-name=1.0.3 --build-number=3

# Plan new
- New Database Design
  Database :
    - kumpulan_lirik_lagu_nasional
      - lyric_id
        - title
        - maker
        - lyric
        - desc
        - video_id
        - audio_url
        - cover_image
          - url
          - source

- Home Page
  - Remake list item using cover_image, to make look more beutiful

- Detail Page
  - revisi setiap video_id yang telah di input dijson, cari yang pas sesuai dengan lirik
  - hapus video youtube, jangan putar youtube di halaman ini
  - bikin tombol untuk navigasi user ke youtube dengan  video_id yang sudah di tambahkan dijson
  - tambahkan pemutar audio di atas lirik, sehingga user dapat mendengar lagu nya ketika melihat lirik
  - audio tidak dapat diputar apabila tidak ada koneksi internet

- About Page
  - There will be current version of the app at the bottom of page
  - 

# Advanced Feature Plan
- Tambah efek karoke di lirik lagu yang sinkron dengan audionya
- Fitur Cari Lagu

# Plan old
Page :
- Splash Screen Page (done)
- Home Page (done)
  - Drawer (done)
  - ListView (done)
    - Item
      - Judul
      - Pencipta lagu
- Detail Page (done)
  - Video tentang lagu (done but will get remove)
  - Judul (done)
  - Diciptakan oleh (done)
  - Lirik (done)
  - Deskripsi (for now not using any deskripsi)
- About Page (done)
  - Instagram (done)
  - Facebook (done)
  - Twitter (done)
  - LinkedIn (done)
  - Github (done)
- Privacy Policy Page (done)
  - Tulisan privacy policy (done)
  
Database :
- Lyrics
  - lyric_id
    - title
    - maker
    - lyric
    - desc
    - video_url
