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
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE FUNCTION yeteneksahipleri (aranan VARCHAR(20) )
RETURNS TABLE(Karakteradi VARCHAR(50),yetenekadi VARCHAR(50),turu VARCHAR(50) )
AS $$
DECLARE 
	Yetid int;
BEGIN
	SELECT "ID" FROM Yetenekler WHERE "Tur"="aranan" INTO Yetid;
	RETURN QUERY SELECT * FROM Karakter INNER JOIN Yetenek_Agaci ON Karakter.ID=Yetenek_Agaci.ID 
	WHERE "Yetenek_Agaci"."1_Yetenek_ID"=Yetid 
	OR "Yetenek_Agaci"."2_Yetenek_ID"=Yetid 
	OR "Yetenek_Agaci"."3_Yetenek_ID"=Yetid 
	OR "Yetenek_Agaci"."4_Yetenek_ID"=Yetid 
	OR "Yetenek_Agaci"."5_Yetenek_ID"=Yetid;
END; $$
LANGUAGE 'plpgsql';
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION "yetenekdegisikligi"()
RETURNS TRIGGER 
AS
$$
BEGIN
    IF NEW."Ad" <> OLD."Ad" THEN
        INSERT INTO "yetenekdegisimi"("Ad", "Tur", "Mana", "Yenilenme_Suresi(Sn)","Hasar","Bonus")
        VALUES(NEW."Ad", NEW."Tur", NEW."Mana", NEW."Yenilenme_Suresi(Sn)",NEW."Hasar",NEW."Bonus");
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "yetenekdegisikliginde"
BEFORE UPDATE ON ""Yetenekler""
FOR EACH ROW
EXECUTE PROCEDURE "yetenekdegisikligi"();
/*--------------------------------------------------------------------------------------------------------------------------------------------*/


CREATE OR REPLACE FUNCTION "sifreekleme"()
RETURNS TRIGGER 
AS
$$
DECLARE ysifre VARCHAR(500 );
BEGIN
 ysifre= SELECT MD5(NEW."Sifre");
       INSERT INTO "Hesap"("Sifre") VALUES (ysifre);
       END;
$$
 LANGUAGE "plpgsql";
 
 
CREATE TRIGGER "sifreeklemesi"
BEFORE UPDATE ON "Hesap"
FOR EACH ROW
EXECUTE PROCEDURE "sifreekleme"();
 
 /*--------------------------------------------------------------------------------------------------------------------------------------------*/
 
CREATE OR REPLACE FUNCTION ""()
RETURNS TRIGGER 
AS
$$

$$
 LANGUAGE "plpgsql";
 /*--------------------------------------------------------------------------------------------------------------------------------------------*/
 CREATE FUNCTION Siralama ()
RETURNS TABLE(Karakteradipvp VARCHAR(50),pvp INT )
AS $$

BEGIN
	RETURN QUERY SELECT "ID","PVP_puani " FROM "Puan_Tablosu" ORDER BY  "PVP_puani" DESC LIMIT 10;
	
END; $$
LANGUAGE 'plpgsql';
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE FUNCTION ticaretKlaniuyeleri ()
RETURNS TABLE(Karakteradi VARCHAR(50) )
AS $$
DECLARE 
	idd int;
BEGIN
	SELECT "ID" FROM "Klan" WHERE "Tur"="ticaret" INTO idd;
	RETURN QUERY SELECT "Ad" FROM Karakter INNER JOIN "Klan_uyeleri" ON Karakter.ID=Klan_uyeleri.ID 
	WHERE "Klan_ID"=idd;
END; $$
LANGUAGE 'plpgsql';
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE FUNCTION developer ()
RETURNS TEXT
AS $$
DECLARE
    sonuc TEXT:='Islem tamamlandi';
    BEGIN
    UPDATE "Karakter" SET "Can"=999 WHERE "ID"=(SELECT "Karakter_ID" FROM "Hesap" WHERE "Karakter_ID"="Developer");
    RETURN TEXT;
   END; $$
LANGUAGE 'plpgsql';
 /*-------------------------------------------------------------------------------------------*/
 CREATE OR REPLACE FUNCTION "ciftyetenek"()
RETURNS TRIGGER 
AS
$$
BEGIN
   LOOP
   
   
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "yetenekayarlma"
AFTER DELETE ON "Yetenek_Agaci"
FOR EACH ROW
EXECUTE PROCEDURE "ciftyetenek"();
 