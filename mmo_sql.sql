CREATE DATABASE "MMO_odev"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

CREATE TABLE "Yetenekler" (
  "ID" INT  ,
	"Ad" VARCHAR(50),
  "Tur" VARCHAR(50),
  "Mana" INT,
  "Yenilenme_Suresi(Sn)" INT,
  "Hasar" INT,
  "Bonus" VARCHAR(100),
	CONSTRAINT "YIDPK" PRIMARY KEY("ID")
);
CREATE TABLE "Hesap" (
  "ID" INT,
  "E_mail" VARCHAR(50),
  "Sifre" VARCHAR(50),
  "Ad" VARCHAR(50),
  "Tur" VARCHAR(20),
  "Karakter_ID" INT,
	CONSTRAINT "HIDPK" PRIMARY KEY("ID"),
	CONSTRAINT "KFK1" FOREIGN KEY("Karakter_ID") REFERENCES "Karakter"("ID")
);

CREATE TABLE "Karakter" (
  "ID" INT,
  "Ad" VARCHAR(50),
  "Seviye" INT,
  "Sinif" VARCHAR(20),
  "Can" INT,
  "Mana" INT,
	CONSTRAINT "KIDPK" PRIMARY KEY("ID")
);

CREATE TABLE "Envanter" (
  "Karakter_ID" INT  ,
  "Nesne_ID" INT  ,
  "Miktar" INT,
	CONSTRAINT "EFK1" FOREIGN KEY("Karakter_ID") REFERENCES "Karakter"("ID")
);

CREATE TABLE "Yetenek_Agaci" (
  "Karakter_ID" INT,
  "1_Yetenek_ID" INT,
  "2_Yetenek_ID" INT,
  "3_Yetenek_ID" INT,
  "4_Yetenek_ID" INT,
  "5_Yetenek_ID" INT,
	CONSTRAINT "KFK2" FOREIGN KEY("Karakter_ID") REFERENCES "Karakter"("ID"),
	CONSTRAINT "YFK1" FOREIGN KEY("1_Yetenek_ID") REFERENCES "Yetenekler"("ID"),
	CONSTRAINT "YFK2" FOREIGN KEY("2_Yetenek_ID") REFERENCES "Yetenekler"("ID"),
	CONSTRAINT "YFK3" FOREIGN KEY("3_Yetenek_ID") REFERENCES "Yetenekler"("ID"),
	CONSTRAINT "YFK4" FOREIGN KEY("4_Yetenek_ID") REFERENCES "Yetenekler"("ID"),
	CONSTRAINT "YFK5" FOREIGN KEY("5_Yetenek_ID") REFERENCES "Yetenekler"("ID")
);

CREATE TABLE "Gorev" (
  "ID" INT  ,
  "Ad" VARCHAR(50),
  "Seviye" INT,
  "Aciklama" VARCHAR(100),
  "Puan" INT,
  "Odul_ID" INT,
	CONSTRAINT "GIDPK" PRIMARY KEY("ID"),
	CONSTRAINT "OFK1" FOREIGN KEY("Odul_ID") REFERENCES "Odul"("ID")
);

CREATE TABLE "Non_Playable_Character" (
  "ID" INT,
  "Ad" VARCHAR(50),
  "Seviye" INT,
  "Sinif" VARCHAR(20),
  "Can" INT,
  "Mana" INT,
  "Tur" VARCHAR(50),
  "Gorev_ID" INT,
	CONSTRAINT "NPCIDPK" PRIMARY KEY("ID"),
	CONSTRAINT "NPCFK1" FOREIGN KEY("Gorev_ID") REFERENCES "Gorev"("ID")
);
CREATE TABLE "Klan" (
  "ID" INT  ,
  "Ad" VARCHAR,
  "Tur" VARCHAR,
	CONSTRAINT "KlanIDPK" PRIMARY KEY("ID")
);

CREATE TABLE "Klan_uyeleri" (
  "Karakter_ID" INT,
  "Klan_ID" INT,
  CONSTRAINT "LFK1" FOREIGN KEY("Karakter_ID") REFERENCES "Karakter"("ID"),
  CONSTRAINT "LFK2" FOREIGN KEY("Klan_ID") REFERENCES "Klan"("ID")
);


CREATE TABLE "Puan_Tablosu" (
  "Karakter_ID" INT,
  "Sezon" INT,
  "PVE_puani " INT,
  "PVP_puani " INT,
	CONSTRAINT "PFK1" FOREIGN KEY("Karakter_ID") REFERENCES "Karakter"("ID")
);
CREATE SCHEMA "Nesneler";

CREATE TABLE "Nesneler"."Nesneler"(
"ID" INT, 
"Ad" VARCHAR(50),
"Aciklama" VARCHAR(100), 
CONSTRAINT "NIDPK" PRIMARY KEY ("ID")
)
CREATE TABLE "Nesneler"."Silahlar"(
"ID" INT,
"Seviye" INT,
"Hasar tipi" VARCHAR(20),
"Hasar" INT,
CONSTRAINT "SPK" PRIMARY KEY ("ID") 
)
CREATE TABLE "Nesneler"."Zirhlar"(
"ID" INT,
"Seviye" INT,
"Zirh tipi" VARCHAR(20),
"Zirh degeri" INT,
CONSTRAINT "ZPK" PRIMARY KEY ("ID") 
)
CREATE TABLE "Nesneler"."Sarfmalzemeleri"(
"ID" INT,
"Etki" VARCHAR(20),
CONSTRAINT "MPK" PRIMARY KEY ("ID") 
)
CREATE TABLE "Nesneler"."Uretim"(
"ID" INT,
"Madde tipi" VARCHAR(20),
CONSTRAINT "UPK" PRIMARY KEY ("ID") 
)
CREATE TABLE "Odul"(
"ID" INT,
"Aciklama" VARCHAR(50),
"Para" INT,
"Seviye" INT,
CONSTRAINT "OIDPK" PRIMARY KEY("ID")
) 
