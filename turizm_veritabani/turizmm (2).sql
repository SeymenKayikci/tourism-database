-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost:8889
-- Üretim Zamanı: 29 Ara 2023, 15:22:02
-- Sunucu sürümü: 5.7.39
-- PHP Sürümü: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `turizmm`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `2021'den sonra incelenmiş 5'ten yüksek puan alan otellerin bilgi` ()   select * from inceleme
inner join otel on inceleme.otel_id = otel.otel_id
where inceleme.tarih > '2021-01-01' and inceleme.puan > 5$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2024 yılında gelecek müşterilerin kişisel bilgisine göre ayrı` ()   select musteri.diger_kisisel_bilgiler, count(musteri.diger_kisisel_bilgiler) as 'Müşteri Sayısı' from musteri
inner join rezervasyon on musteri.musteri_id = rezervasyon.musteri_id
where rezervasyon.giris_tarihi between '2024-01-01' and '2025-01-01'
group by musteri.diger_kisisel_bilgiler$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2024'ten önce iyi yorum verenlerin rezervasyon bilgileri` ()   select * from rezervasyon
inner join inceleme on rezervasyon.inceleme_id = inceleme.inceleme_id
where inceleme.tarih < '2024-01-01' and inceleme.yorum like '%iyi%'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2024'ün ilk yarısında yapılan rezervasyonların oda tipine göre g` ()   select oda_tipi.oda_tipi_adi, count(oda_tipi_adi) from oda_tipi
inner join rezervasyon on oda_tipi.oda_tipi_id = rezervasyon.oda_tipi_id
where rezervasyon.giris_tarihi < '2024-06-01'
group by oda_tipi.oda_tipi_adi
order by count(oda_tipi.oda_tipi_adi) desc$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `31-12-2023'ten sonra başlayacak ve muğla veya izmire düzenlenece` ()   select * from gezi_tablosu
inner join konum on gezi_tablosu.konum_id = konum.konum_id
where gezi_tablosu.baslangic_tarihi > '2023-12-31' and konum.sehir in ('mugla', 'izmir')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `5 yıllık pasaportu olup vize nedeni öğrenci olanlar` ()   select * from pasaport
inner join vize on pasaport.pasaport_id = vize.pasaport_id
where vize.talep_nedeni like 'ogrenci' and pasaport.pasaport_suresi like '5 yil'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `abd'deki içecek içilebilecek restoranlar` ()   select * from restoran
inner join konum on restoran.konum_id = konum.konum_id
where ulke like 'abd' and menu like '%icecek%'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ad-soyada göre vize ve pasaport bilgileri görüntüleme` (IN `isim` VARCHAR(255), IN `soyisim` VARCHAR(255))   SELECT CONCAT(vize.ad, ' ', vize.soyad) AS Ad_Soyad, vize.vize_bilgileri, pasaport.pasaport_id
FROM vize, pasaport
WHERE vize.pasaport_id = pasaport.pasaport_id AND vize.ad LIKE concat('%',isim,'%') OR vize.soyad LIKE concat('%',soyisim,'%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ada_gore_etkinlik_listele` (IN `ad` VARCHAR(255))  NO SQL SELECT *
FROM etkinlik, konum
WHERE etkinlik.konum_id = konum.konum_id AND etkinlik.etkinlik_adi LIKE concat('%',ad,'%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gmail'i olup, tatiline 5 puan üzeri puanlama yapan müşteriler` ()   select * from inceleme
inner join musteri on inceleme.musteri_id = musteri.musteri_id
where inceleme.puan > 5 and mail like '%gmail.com'
order by inceleme.puan desc$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inceleme puanı 3'ten büyük olup yıldız sayısı 2'den büyük olan o` ()   select otel.yildiz_sayisi, count(otel.yildiz_sayisi) from inceleme
inner join otel on inceleme.otel_id = otel.otel_id
where inceleme.puan > 3
group by otel.yildiz_sayisi
having otel.yildiz_sayisi > 2$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `türkiye'de düzenlenecek turnuvalar` ()   select * from etkinlik
inner join konum on etkinlik.konum_id = konum.konum_id
where etkinlik.etkinlik_adi like '%turnuva%' and konum.ulke like 'turkiye'$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `etkinlik`
--

CREATE TABLE `etkinlik` (
  `etkinlik_id` int(11) NOT NULL,
  `konum_id` int(11) DEFAULT NULL,
  `etkinlik_adi` varchar(50) DEFAULT NULL,
  `tarih` datetime DEFAULT NULL,
  `diger_etkinlik_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `etkinlik`
--

INSERT INTO `etkinlik` (`etkinlik_id`, `konum_id`, `etkinlik_adi`, `tarih`, `diger_etkinlik_bilgileri`) VALUES
(1, 10, 'oyun etkinliği', '2024-03-22 00:00:00', 'sadece 18 yaş altı bireyler katılabilmektedir'),
(2, 4, 'dart etkinliği', '2024-03-23 00:00:00', '18 yaş ve üstü bireyler katılım sağlayabilmektedir'),
(3, 2, 'masa tenisi', '2024-03-24 00:00:00', 'her yaş grubu etkinliğe katılım gösterebilmektedirler'),
(4, 3, 'basketbol turnuvası', '2024-04-25 00:00:00', '3\'er kişilik takımlar halinde katılım olucaktır'),
(5, 9, 'futbol turnuvası', '2024-03-26 00:00:00', '5\'er kişilik takımlar halinde katılım olucaktır'),
(6, 8, 'su topu turnuvası', '2024-05-05 00:00:00', '4\'er kişilik takımlar halinde katılım olucaktır'),
(7, 7, 'lego puzzle etkinliği', '2024-03-28 00:00:00', 'çocuk katılımcılar aile bireylerinin refakatlariyle katılabilicektir'),
(8, 1, 'palyaço etkinliği', '2024-02-15 00:00:00', '4-12 yaş arası katılımcılar için uygundur'),
(9, 5, 'disco dj aktivitesi', '2024-03-29 00:00:00', 'otelimize gelicek ünlü dj\'lerle güzel bir gece'),
(10, 6, 'bilardo turnuvası', '2024-06-28 00:00:00', 'Semih Saygıner\'le birlikte bilardo oynama fırsatı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `gezi_tablosu`
--

CREATE TABLE `gezi_tablosu` (
  `gezi_id` int(11) NOT NULL,
  `konum_id` int(11) DEFAULT NULL,
  `baslangic_tarihi` datetime DEFAULT NULL,
  `bitis_tarihi` datetime DEFAULT NULL,
  `diger_gezi_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `gezi_tablosu`
--

INSERT INTO `gezi_tablosu` (`gezi_id`, `konum_id`, `baslangic_tarihi`, `bitis_tarihi`, `diger_gezi_bilgileri`) VALUES
(1, 10, '2024-01-01 00:00:00', '2024-01-03 00:00:00', 'Ankara Turu'),
(2, 1, '2024-02-02 00:00:00', '2024-02-08 00:00:00', 'İzmir Turu'),
(3, NULL, '2024-02-18 00:00:00', '2024-02-28 00:00:00', 'Hollanda Turu'),
(4, NULL, '2024-03-05 00:00:00', '2024-03-06 00:00:00', 'Çanakkale Turu'),
(5, 5, '2024-03-10 00:00:00', '2024-04-10 00:00:00', 'Las Vegas Turu'),
(6, NULL, '2024-04-22 00:00:00', '2024-04-30 00:00:00', 'New York Turu'),
(7, 2, '2024-05-05 00:00:00', '2024-05-12 00:00:00', 'Bodrum Turu'),
(8, 6, '2024-05-18 00:00:00', '2024-05-22 00:00:00', 'Antalya Turu'),
(9, 2, '2024-06-13 00:00:00', '2024-06-25 00:00:00', 'Marmaris Turu'),
(10, 4, '2024-08-11 00:00:00', '2024-09-11 00:00:00', 'Miami Turu');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `inceleme`
--

CREATE TABLE `inceleme` (
  `inceleme_id` int(11) NOT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `otel_id` int(11) DEFAULT NULL,
  `puan` varchar(10) DEFAULT NULL,
  `yorum` varchar(255) DEFAULT NULL,
  `tarih` datetime DEFAULT NULL,
  `diger_inceleme_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `inceleme`
--

INSERT INTO `inceleme` (`inceleme_id`, `musteri_id`, `otel_id`, `puan`, `yorum`, `tarih`, `diger_inceleme_bilgileri`) VALUES
(1, 1, 7, '8', 'çok iyi', '2024-01-01 00:00:00', 'konum harici her şey mükemmel'),
(2, 10, 8, '7', 'gayet iyi', '2024-01-02 00:00:00', 'yemekler harici  güzeldi. Konum biraz soğuktu.'),
(3, 6, 3, '3', 'kötü', '2023-08-25 00:00:00', 'Oda temiz değil, yemekler ve hizmet kötüydü'),
(4, 2, 6, '5', 'ortalama', '2024-04-29 00:00:00', 'Vasat bir konaklama tesisydi. tekrar tercih etmem'),
(5, 5, 4, '10', 'kusursuz', '2023-12-31 00:00:00', 'Harika bir yılbaşı tatiliydi'),
(6, 9, 1, '4', 'kötünün iyisi', '2024-03-04 00:00:00', 'Çalışanlar ilgisiz yemekler kötüydü'),
(7, 8, 9, '9', 'mükemmel', '2025-02-06 00:00:00', 'Yemekler ilgi alaka ve odanın kalitesi mükemmeldi'),
(8, 3, 2, '1', 'berbat', '2022-06-24 00:00:00', 'Kesinlikle gidilmemesi gereken berbat bir pansiyon'),
(9, 4, 5, '6', 'iyi', '2021-09-11 00:00:00', 'ortalamanın üstü güzel bir pansiyon tavsiye ederim'),
(10, 7, 10, '2', 'çok kötü', '2019-11-30 00:00:00', 'Yemeklerinden zehirlendik ve kışın ortasında ısıtıcı çalışmıyordu kesinlikle tavsiye etmiyorum');

--
-- Tetikleyiciler `inceleme`
--
DELIMITER $$
CREATE TRIGGER `log_guncellenen_incelemeler` AFTER UPDATE ON `inceleme` FOR EACH ROW INSERT INTO log_guncellenen_incelemeler VALUES(
old.inceleme_id,
    old.musteri_id,
    new.diger_inceleme_bilgileri
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `konum`
--

CREATE TABLE `konum` (
  `konum_id` int(11) NOT NULL,
  `sehir` varchar(20) DEFAULT NULL,
  `ulke` varchar(20) DEFAULT NULL,
  `bolge` varchar(20) DEFAULT NULL,
  `diger_konum_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `konum`
--

INSERT INTO `konum` (`konum_id`, `sehir`, `ulke`, `bolge`, `diger_konum_bilgileri`) VALUES
(1, 'İzmir', 'Türkiye', 'Ege Bölgesi', '-'),
(2, 'Muğla', 'Türkiye', 'Ege Bölgesi', 'Yazlık Bölge'),
(3, 'Trabzon', 'Türkiye', 'Karadeniz Bölgesi', 'Yağış Boldur'),
(4, 'Miami', 'ABD', 'Florida Eyaleti', 'Turizm sektörü oldukça gelişmiştir'),
(5, 'Las Vegas', 'ABD', 'Nevada Eyaleti', 'Vegas\'ta olan Vegas\'ta kalır'),
(6, 'Antalya', 'Türkiye', 'Akdeniz Bölgesi', 'Yazın turisti bol bir yazlık şehirdir'),
(7, 'Londra', 'İngiltere', 'Büyük Britanya Adası', 'Başkent'),
(8, 'Adana', 'Türkiye', 'Akdeniz Bölgesi', 'Bunaltıcı sıcak ve insanlarıyla meşhur bir şehirdir'),
(9, 'İstanbul', 'Türkiye', 'Marmara Bölgesi', 'Ülkenin en fazla nüfusu ve Ekonomik, tarihî ve sosyo-kültürel açıdan önde gelen şehirlerden biridir'),
(10, 'Ankara', 'Türkiye', 'İç Anadolu Bölgesi', 'Başkent');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `log_guncellenen_incelemeler`
--

CREATE TABLE `log_guncellenen_incelemeler` (
  `inceleme_id` int(11) DEFAULT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `diger_inceleme_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `log_guncellenen_incelemeler`
--

INSERT INTO `log_guncellenen_incelemeler` (`inceleme_id`, `musteri_id`, `diger_inceleme_bilgileri`) VALUES
(2, 10, 'yemekler harici  güzeldi. Konum biraz soğuktu.'),
(4, 2, 'Vasat bir konaklama tesisydi. tekrar tercih etmem'),
(9, 4, 'ortalamanın üstü güzel bir pansiyon tavsiye ederim');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `log_iptal_rezervasyon`
--

CREATE TABLE `log_iptal_rezervasyon` (
  `rez_id` int(11) DEFAULT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `otel_id` int(11) DEFAULT NULL,
  `oda_tipi_id` int(11) DEFAULT NULL,
  `giris_tarihi` datetime DEFAULT NULL,
  `cikis_tarihi` datetime DEFAULT NULL,
  `odeme_bilgileri` varchar(100) DEFAULT NULL,
  `diger_rezervasyon_bilgileri` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `log_iptal_rezervasyon`
--

INSERT INTO `log_iptal_rezervasyon` (`rez_id`, `musteri_id`, `otel_id`, `oda_tipi_id`, `giris_tarihi`, `cikis_tarihi`, `odeme_bilgileri`, `diger_rezervasyon_bilgileri`) VALUES
(11, 6, 6, 4, '2023-12-01 12:35:47', '2023-12-29 12:35:47', 'nakit', 'test test silinecek'),
(9, 4, 5, 4, '2024-08-16 00:00:00', '2024-08-21 00:00:00', 'kredi karti', '12 taksit');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `log_rez_guncelleme`
--

CREATE TABLE `log_rez_guncelleme` (
  `rezervasyon_id` int(11) DEFAULT NULL,
  `eski_giris` datetime DEFAULT NULL,
  `eski_cikis` datetime DEFAULT NULL,
  `yeni_giris` datetime DEFAULT NULL,
  `yeni_cikis` datetime DEFAULT NULL,
  `odeme_bilgileri` varchar(255) NOT NULL,
  `diger_rezervasyon_bilgileri` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `log_rez_guncelleme`
--

INSERT INTO `log_rez_guncelleme` (`rezervasyon_id`, `eski_giris`, `eski_cikis`, `yeni_giris`, `yeni_cikis`, `odeme_bilgileri`, `diger_rezervasyon_bilgileri`) VALUES
(10, '2024-09-01 00:00:00', '2024-09-11 00:00:00', '2024-09-03 00:00:00', '2024-09-11 00:00:00', 'nakit', '-'),
(10, '2024-09-03 00:00:00', '2024-09-11 00:00:00', '2024-09-03 00:00:00', '2024-09-11 00:00:00', 'kredi kartı', '-'),
(10, '2024-09-03 00:00:00', '2024-09-11 00:00:00', '2024-09-04 00:00:00', '2024-09-12 00:00:00', 'kredi kartı', '-');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri`
--

CREATE TABLE `musteri` (
  `musteri_id` int(11) NOT NULL,
  `ad` varchar(50) DEFAULT NULL,
  `soyad` varchar(50) DEFAULT NULL,
  `telefon` varchar(11) DEFAULT NULL,
  `mail` varchar(50) DEFAULT NULL,
  `diger_kisisel_bilgiler` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `musteri`
--

INSERT INTO `musteri` (`musteri_id`, `ad`, `soyad`, `telefon`, `mail`, `diger_kisisel_bilgiler`) VALUES
(1, 'Seymen', 'Kayikci', '5359348243', 'seymenkayikci@hotmail.com', 'ogrenci'),
(2, 'Emre', 'Aslan', '5354678901', 'emreaslan@gmail.com', 'ogrenci'),
(3, 'Mehmet', 'Donmez', '5467891123', 'donmezmemo@hotmail.com', 'turizmci'),
(4, 'Şafak', 'Seven', '532456327', 'sfksvn@icloud.com', 'turizmci'),
(5, 'Baturay', 'Temel', '2324536789', 'tmlbaturayqhotmail.com', 'ogrenci'),
(6, 'Ahmet', 'Durmaz', '567890324', 'durmazemre@gmail.com', 'ogrenci'),
(7, 'Burak', 'Evrentug', '2343646789', 'burakevrentug@gmail.com', 'ogretim gorevlisi'),
(8, 'Seyhmus', 'Akin', '578324742', 'seyhmusakin@hotmail.com', 'ogrenci'),
(9, 'Serda', 'Poyraz', '678923456', 'serdapoyraz@gmail.com', 'isletme sahibi'),
(10, 'Mahir', 'Diler', '1657893456', 'dilrmahir@gmail.com', 'isletme sahibi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `oda_tipi`
--

CREATE TABLE `oda_tipi` (
  `oda_tipi_id` int(11) NOT NULL,
  `oda_tipi_adi` varchar(20) DEFAULT NULL,
  `kapasite` varchar(20) DEFAULT NULL,
  `fiyat` varchar(20) DEFAULT NULL,
  `diger_oda_tipi_bilgileri` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `oda_tipi`
--

INSERT INTO `oda_tipi` (`oda_tipi_id`, `oda_tipi_adi`, `kapasite`, `fiyat`, `diger_oda_tipi_bilgileri`) VALUES
(1, 'standart', '3', '3000', 'Klasik aile odasi'),
(2, 'Kral dairesi', '5', '15000', 'otesi yok'),
(3, 'Tek kisilik oda', '1', '1000', '-'),
(4, 'cift kisilik oda', '2', '2000', '-'),
(5, 'Engelli odasi', '2', '500', 'ozel oda'),
(6, 'Junior Suite', '3', '2000', 'cocuk odasi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `otel`
--

CREATE TABLE `otel` (
  `otel_id` int(11) NOT NULL,
  `otel_adi` varchar(50) DEFAULT NULL,
  `adres` varchar(255) DEFAULT NULL,
  `telefon` varchar(11) DEFAULT NULL,
  `yildiz_sayisi` varchar(10) DEFAULT NULL,
  `diger_otel_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `otel`
--

INSERT INTO `otel` (`otel_id`, `otel_adi`, `adres`, `telefon`, `yildiz_sayisi`, `diger_otel_bilgileri`) VALUES
(1, 'Hilton', 'Izmir', '232', '5', 'Izmir\'in merkezinde konforlu bir yasam deneyimi'),
(2, 'Ontur', 'Cesme', '330', '5', '-'),
(3, 'Sheraton', 'Cesme', '353', '5', 'Kusursuz bir tatil deneyimi'),
(4, 'Kaya Belek', 'Antalya', '242', '5', '-'),
(5, 'Rixos Premium', 'Bodrum', '321', '4', 'Merkezden uzak dogayla ic ice'),
(6, 'Aslan Hotel', 'Londra', '033', '3', 'Huzur verici bir dinlenme tesisi'),
(7, 'Kayikci Hotel', 'Trabzon', '616', '5', 'Yagmur sesleriyle yeniden dogus'),
(8, 'Mutlu Hotel', 'Marmaris', '435', '2', '-'),
(9, 'Lara Homes', 'Antalya', '555', '4', 'Antalya Havalimanı\'na 9 km, Düden Şelalesi\'ne 5 km ve Akdeniz kıyısındaki Lara Plajı\'na 3 km uzaklıktadır.'),
(10, 'Vegas Hotel', 'Las Vegas', '000', '5', 'Unutulmuycak anılar biriktirin');

--
-- Tetikleyiciler `otel`
--
DELIMITER $$
CREATE TRIGGER `trigger1` BEFORE INSERT ON `otel` FOR EACH ROW SET NEW.otel_adi= CONCAT(UCASE(LEFT(NEW.otel_adi,1)) , LCASE(SUBSTRING(NEW.otel_adi,2)))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `pasaport`
--

CREATE TABLE `pasaport` (
  `pasaport_id` int(11) NOT NULL,
  `pasaport_cesidi` varchar(10) DEFAULT NULL,
  `ad` varchar(50) DEFAULT NULL,
  `soyad` varchar(50) DEFAULT NULL,
  `pasaport_suresi` varchar(20) DEFAULT NULL,
  `diger_pasaport_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `pasaport`
--

INSERT INTO `pasaport` (`pasaport_id`, `pasaport_cesidi`, `ad`, `soyad`, `pasaport_suresi`, `diger_pasaport_bilgileri`) VALUES
(1, 'bordo', 'Seymen', 'Kayıkçı', '5 yil', 'ogrenci'),
(2, 'bordo', 'Baturay', 'Temel', '5 yil', 'ogrenci'),
(3, 'yesil', 'Safak', 'Seven', '10 Yil', 'hususi'),
(4, 'pembe', 'Aleyna', 'Karpat', '3 ay', 'gecici'),
(5, 'bordo', 'Seyhmus', 'Akin', '5 yil', 'ogrenci'),
(6, 'siyah', 'Emre', 'Aslan', 'suresiz', 'diplomatik'),
(7, 'yesil', 'Selin', 'Balaban', '10 yil', 'hususi'),
(8, 'bordo', 'Serda', 'Poyraz', '5yil', 'ogrenci'),
(9, 'bordo', 'Berke', 'Ozdamar', '4yil', 'ogrenci'),
(10, 'siyah', 'Gorkem', 'Kocak', 'suresiz', 'diplomatik');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `restoran`
--

CREATE TABLE `restoran` (
  `restoran_id` int(11) NOT NULL,
  `konum_id` int(11) DEFAULT NULL,
  `restoran_adi` varchar(50) DEFAULT NULL,
  `menu` varchar(255) DEFAULT NULL,
  `fiyat_araligi` varchar(255) DEFAULT NULL,
  `diger_restoran_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `restoran`
--

INSERT INTO `restoran` (`restoran_id`, `konum_id`, `restoran_adi`, `menu`, `fiyat_araligi`, `diger_restoran_bilgileri`) VALUES
(1, 9, 'Fabrice', 'Icecek, Yiyecek', '500-10000', 'kokteyl bar'),
(2, 6, 'Fae', 'Icecek, Yiyecek', '500-20000', 'kokteyl bar'),
(3, 3, 'Kofteci Yusuf', 'Yiyecek, Icecek', '100,500', 'yiyecek uzerine'),
(4, 1, 'Tuck', 'Icecek, Yiyecek', '50-100', 'kahve mekani'),
(5, 4, 'Starbucks', 'Icecek, Yiyecek', '50-200', 'kahve mekani'),
(6, 5, 'Lipp', 'Icecek', '500-15000', 'kokteyl ve eglence'),
(7, 8, 'McDonals', 'Yiyecek', '100-500', 'yiyecek uzerine'),
(8, 7, 'Baydoner', 'Yiyecek', '200-1000', 'yiyecek uzerine'),
(9, 2, 'Popeyes', 'Yiyecek', '100-500', 'yiyecek uzerine'),
(10, 10, 'Acarlar', 'Yiyecek', '50-500', 'kahvaltı uzerine');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `rezervasyon`
--

CREATE TABLE `rezervasyon` (
  `rezervasyon_id` int(11) NOT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `otel_id` int(11) DEFAULT NULL,
  `oda_tipi_id` int(11) DEFAULT NULL,
  `giris_tarihi` datetime DEFAULT NULL,
  `cikis_tarihi` datetime DEFAULT NULL,
  `odeme_bilgileri` varchar(20) DEFAULT NULL,
  `diger_rezervasyon_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `rezervasyon`
--

INSERT INTO `rezervasyon` (`rezervasyon_id`, `musteri_id`, `otel_id`, `oda_tipi_id`, `giris_tarihi`, `cikis_tarihi`, `odeme_bilgileri`, `diger_rezervasyon_bilgileri`) VALUES
(1, 6, 6, 6, '2024-01-01 00:00:00', '2024-01-03 00:00:00', 'kredi karti', '3 taksit'),
(2, 5, 4, 1, '2024-01-05 00:00:00', '2024-01-10 00:00:00', 'nakit', '-'),
(3, 10, 1, 2, '2024-02-08 00:00:00', '2024-02-12 00:00:00', 'kredi karti', 'tek cekim'),
(4, 2, 2, 4, '2024-02-10 00:00:00', '2024-02-15 00:00:00', 'kredi karti', '6 taksit'),
(5, 3, 8, 3, '2024-03-03 00:00:00', '2024-03-09 00:00:00', 'nakit', '-'),
(6, 9, 3, 6, '2024-04-12 00:00:00', '2024-04-22 00:00:00', 'kredi karti', '3 taksit'),
(7, 1, 10, 2, '2024-05-26 00:00:00', '2024-05-31 00:00:00', 'nakit', '-'),
(8, 8, 9, 3, '2024-06-17 00:00:00', '2024-06-19 00:00:00', 'kredi karti', 'tek cekim'),
(10, 7, 4, 1, '2024-09-04 00:00:00', '2024-09-12 00:00:00', 'kredi kartı', '-');

--
-- Tetikleyiciler `rezervasyon`
--
DELIMITER $$
CREATE TRIGGER `guncellenen_rezervasyonlar` AFTER UPDATE ON `rezervasyon` FOR EACH ROW INSERT INTO log_rez_guncelleme VALUES(
old.rezervasyon_id,
    old.giris_tarihi,
    old.cikis_tarihi,
    new.giris_tarihi,
    new.cikis_tarihi,
    new.odeme_bilgileri,
    new.diger_rezervasyon_bilgileri
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_iptal_rezervasyonlar` BEFORE DELETE ON `rezervasyon` FOR EACH ROW INSERT INTO log_iptal_rezervasyon VALUES
(
old.rezervasyon_id,
old.musteri_id,
    old.otel_id,
    old.oda_tipi_id,
    old.giris_tarihi,
    old.cikis_tarihi,
    old.odeme_bilgileri,
    old.diger_rezervasyon_bilgileri
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ulasim`
--

CREATE TABLE `ulasim` (
  `ulasim_id` int(11) NOT NULL,
  `ulasim_araci` varchar(50) DEFAULT NULL,
  `kalkis_yeri` varchar(50) DEFAULT NULL,
  `varis_yeri` varchar(50) DEFAULT NULL,
  `fiyat` varchar(20) DEFAULT NULL,
  `diger_ulasim_bilgileri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `ulasim`
--

INSERT INTO `ulasim` (`ulasim_id`, `ulasim_araci`, `kalkis_yeri`, `varis_yeri`, `fiyat`, `diger_ulasim_bilgileri`) VALUES
(1, 'Otobüs', 'Ankara', 'Istanbul', '100', '-'),
(2, 'Tren', 'Izmir', 'Antalya', '75', '-'),
(3, 'Uçak', 'Istanbul', 'Ankara', '200', '-'),
(4, 'Araba', 'Antalya', 'Bodrum', '50', '-'),
(5, 'Vapur', 'Istanbul', 'Bursa', '30', '-'),
(6, 'Metro', 'Ankara', 'Eskisehir', '20', '-'),
(7, 'Taksi', 'Izmir', 'Cesme', '40', '-'),
(8, 'Tramvay', 'Istanbul', 'Kadikoy', '10', '-'),
(9, 'Feribot', 'Bodrum', 'Marmaris', '25', '-'),
(10, 'Minibüs', 'Eskisehir', 'Bursa', '15', '-');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `vize`
--

CREATE TABLE `vize` (
  `vize_id` int(11) NOT NULL,
  `pasaport_id` int(11) DEFAULT NULL,
  `vize_bilgileri` varchar(255) DEFAULT NULL,
  `ad` varchar(20) DEFAULT NULL,
  `soyad` varchar(20) DEFAULT NULL,
  `vize_suresi` varchar(20) DEFAULT NULL,
  `talep_nedeni` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `vize`
--

INSERT INTO `vize` (`vize_id`, `pasaport_id`, `vize_bilgileri`, `ad`, `soyad`, `vize_suresi`, `talep_nedeni`) VALUES
(1, 1, 'schengen', 'Seymen', 'Kayikci', '5 yil', 'ogrenci'),
(2, 2, 'schengen', 'Baturay', 'Temel', '5 yil', 'ogrenci'),
(3, 8, 'schengen', 'Seyhmus', 'Akin', '5 yil', 'ogrenci'),
(4, 7, 'turistik', 'Safak', 'Seven', '10 yil', 'gezi'),
(5, 6, 'calisma', 'Mehmet', 'Donmez', 'belirtilmemis', '-'),
(6, 4, 'kapi vizesi', 'Emre', 'Aslan', '1 hafta', 'gezi'),
(7, 4, 'kapi vizesi', 'Serda', 'Poyraz', '10 gun', 'gezi'),
(8, 10, 'turistik', 'Gorkem', 'Kocak', '10 yil', '-'),
(9, 9, 'schengen', 'Aleyna', 'Karpat', '5yil', 'ogrenci'),
(10, 3, 'calisma', 'Selin', 'Balaban', 'suresiz', '-');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `etkinlik`
--
ALTER TABLE `etkinlik`
  ADD PRIMARY KEY (`etkinlik_id`),
  ADD KEY `konum_id` (`konum_id`);

--
-- Tablo için indeksler `gezi_tablosu`
--
ALTER TABLE `gezi_tablosu`
  ADD PRIMARY KEY (`gezi_id`),
  ADD KEY `konum_id` (`konum_id`);

--
-- Tablo için indeksler `inceleme`
--
ALTER TABLE `inceleme`
  ADD PRIMARY KEY (`inceleme_id`),
  ADD KEY `musteri_id` (`musteri_id`),
  ADD KEY `otel_id` (`otel_id`);

--
-- Tablo için indeksler `konum`
--
ALTER TABLE `konum`
  ADD PRIMARY KEY (`konum_id`);

--
-- Tablo için indeksler `musteri`
--
ALTER TABLE `musteri`
  ADD PRIMARY KEY (`musteri_id`);

--
-- Tablo için indeksler `oda_tipi`
--
ALTER TABLE `oda_tipi`
  ADD PRIMARY KEY (`oda_tipi_id`);

--
-- Tablo için indeksler `otel`
--
ALTER TABLE `otel`
  ADD PRIMARY KEY (`otel_id`);

--
-- Tablo için indeksler `pasaport`
--
ALTER TABLE `pasaport`
  ADD PRIMARY KEY (`pasaport_id`);

--
-- Tablo için indeksler `restoran`
--
ALTER TABLE `restoran`
  ADD PRIMARY KEY (`restoran_id`),
  ADD KEY `konum_id` (`konum_id`);

--
-- Tablo için indeksler `rezervasyon`
--
ALTER TABLE `rezervasyon`
  ADD PRIMARY KEY (`rezervasyon_id`),
  ADD KEY `musteri_id` (`musteri_id`),
  ADD KEY `otel_id` (`otel_id`),
  ADD KEY `oda_tipi_id` (`oda_tipi_id`);

--
-- Tablo için indeksler `ulasim`
--
ALTER TABLE `ulasim`
  ADD PRIMARY KEY (`ulasim_id`);

--
-- Tablo için indeksler `vize`
--
ALTER TABLE `vize`
  ADD PRIMARY KEY (`vize_id`),
  ADD KEY `pasaport_id` (`pasaport_id`);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `etkinlik`
--
ALTER TABLE `etkinlik`
  ADD CONSTRAINT `etkinlik_ibfk_1` FOREIGN KEY (`konum_id`) REFERENCES `konum` (`konum_id`);

--
-- Tablo kısıtlamaları `gezi_tablosu`
--
ALTER TABLE `gezi_tablosu`
  ADD CONSTRAINT `gezi_tablosu_ibfk_1` FOREIGN KEY (`konum_id`) REFERENCES `konum` (`konum_id`);

--
-- Tablo kısıtlamaları `inceleme`
--
ALTER TABLE `inceleme`
  ADD CONSTRAINT `inceleme_ibfk_1` FOREIGN KEY (`musteri_id`) REFERENCES `musteri` (`musteri_id`),
  ADD CONSTRAINT `inceleme_ibfk_2` FOREIGN KEY (`otel_id`) REFERENCES `otel` (`otel_id`);

--
-- Tablo kısıtlamaları `restoran`
--
ALTER TABLE `restoran`
  ADD CONSTRAINT `restoran_ibfk_1` FOREIGN KEY (`konum_id`) REFERENCES `konum` (`konum_id`);

--
-- Tablo kısıtlamaları `rezervasyon`
--
ALTER TABLE `rezervasyon`
  ADD CONSTRAINT `rezervasyon_ibfk_1` FOREIGN KEY (`musteri_id`) REFERENCES `musteri` (`musteri_id`),
  ADD CONSTRAINT `rezervasyon_ibfk_2` FOREIGN KEY (`otel_id`) REFERENCES `otel` (`otel_id`),
  ADD CONSTRAINT `rezervasyon_ibfk_3` FOREIGN KEY (`oda_tipi_id`) REFERENCES `oda_tipi` (`oda_tipi_id`);

--
-- Tablo kısıtlamaları `vize`
--
ALTER TABLE `vize`
  ADD CONSTRAINT `vize_ibfk_1` FOREIGN KEY (`pasaport_id`) REFERENCES `pasaport` (`pasaport_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
