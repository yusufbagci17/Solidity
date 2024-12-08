// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Modifiers {
    /**
     * @dev Siparis durumlarini temsil eden enum.
     * Alindi: Siparis alindi.
     * Hazirlaniyor: Siparis hazirlaniyor.
     * Paketlendi: Siparis paketlendi.
     * Kargolandı: Siparis kargoya verildi.
     */
    enum Durum {
        Alindi,
        Hazirlaniyor,
        Paketlendi,
        Kargolandi
    }

    /**
     * @dev Siparis bilgilerini tutan struct.
     * musteri: Siparisi olusturan musterinin adresi.
     * postaKodu: Siparisin gonderilecegi posta kodu.
     * urunler: Siparis edilen urunlerin ID'lerinden olusan liste.
     * durum: Siparisin mevcut durumu.
     */
    struct Siparis {
        address musteri;
        string postaKodu;
        uint256[] urunler;
        Durum durum;
    }

    // Tüm siparisleri tutan liste.
    Siparis[] public siparisler;

    // Kontrat sahibinin adresi.
    address public sahip;

    // Kontrat uzerinden yapilan toplam islem sayisi.
    uint256 public islemSayisi;

    /**
     * @dev Kontrat olusturucu, kontrati dagitan kisiyi sahip olarak atar.
     */
    constructor() {
        sahip = msg.sender;
    }

    /**
     * @dev Yeni bir siparis olusturur.
     * @param _postaKodu Siparisin gonderilecegi posta kodu.
     * @param _urunler Siparis edilen urunlerin ID'lerinden olusan liste.
     * @return Olusturulan siparisin ID'si.
     */
    function siparisOlustur(string memory _postaKodu, uint256[] memory _urunler)
        islemArtir
        urunKontrol(_urunler)
        external
        returns (uint256)
    {
        Siparis memory yeniSiparis = Siparis({
            musteri: msg.sender,
            postaKodu: _postaKodu,
            urunler: _urunler,
            durum: Durum.Alindi
        });

        siparisler.push(yeniSiparis);

        return siparisler.length - 1;
    }

    /**
     * @dev Bir siparisin durumunu bir sonraki asamaya ilerletir.
     * @param _siparisId Ilerletilecek siparisin ID'si.
     */
    function siparisIlerle(uint256 _siparisId)
        siparisKontrol(_siparisId)
        sadeceSahip
        public
    {
        Siparis storage siparis = siparisler[_siparisId];
        require(siparis.durum != Durum.Kargolandi, "Siparis zaten kargolandi.");

        // Siparis durumunu bir sonraki duruma gecir
        if (siparis.durum == Durum.Alindi) {
            siparis.durum = Durum.Hazirlaniyor;
        } else if (siparis.durum == Durum.Hazirlaniyor) {
            siparis.durum = Durum.Paketlendi;
        } else if (siparis.durum == Durum.Paketlendi) {
            siparis.durum = Durum.Kargolandi;
        }
    }

    /**
     * @dev Bir siparisin bilgilerini getirir.
     * @param _siparisId Bilgileri alinacak siparisin ID'si.
     * @return Siparis bilgileri.
     */
    function siparisGetir(uint256 _siparisId)
        siparisKontrol(_siparisId)
        external
        view
        returns (Siparis memory)
    {
        return siparisler[_siparisId];
    }

    /**
     * @dev Bir siparisin posta kodunu gunceller.
     * @param _siparisId Posta kodu guncellenecek siparisin ID'si.
     * @param _posta Yeni posta kodu.
     */
    function postaKoduGuncelle(uint256 _siparisId, string memory _posta)
        sadeceMusteri(_siparisId)
        islemArtir
        siparisKontrol(_siparisId)
        external
    {
        Siparis storage siparis = siparisler[_siparisId];
        siparis.postaKodu = _posta;
    }

    // === Modifier'lar ===

    /**
     * @dev Urun listesinin bos olmadigini kontrol eder.
     */
    modifier urunKontrol(uint256[] memory _urunler) {
        require(_urunler.length > 0, "Urun listesi bos olamaz.");
        _;
    }

    /**
     * @dev Gecerli bir siparis ID'si olup olmadigini kontrol eder.
     */
    modifier siparisKontrol(uint256 _siparisId) {
        require(_siparisId < siparisler.length, "Gecerli bir siparis ID'si degil.");
        _;
    }

    /**
     * @dev Islem sayisini artiran bir modifier.
     */
    modifier islemArtir {
        _;
        islemSayisi++;
    }

    /**
     * @dev Sadece kontrat sahibinin yetkisi olan islemleri kontrol eder.
     */
    modifier sadeceSahip {
        require(msg.sender == sahip, "Yetkiniz yok.");
        _;
    }

    /**
     * @dev Sadece siparis sahibi olan musterinin yetkisi olan islemleri kontrol eder.
     * @param _siparisId Islem yapilacak siparisin ID'si.
     */
    modifier sadeceMusteri(uint256 _siparisId) {
        require(siparisler[_siparisId].musteri == msg.sender, "Siparisin sahibi degilsiniz.");
        _;
    }
}
