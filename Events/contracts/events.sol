// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Etkinlikler {
    /**
     * @dev Sipariş durumlarını temsil eden bir enum yapısı.
     * Alindi: Sipariş alındı, işleme hazır.
     * Hazirlaniyor: Sipariş hazırlanıyor.
     * Paketlendi: Sipariş paketlendi.
     * Kargolandı: Sipariş kargoya verildi.
     */
    enum Durum {
        Alindi,
        Hazirlaniyor,
        Paketlendi,
        Kargolandi
    }

    /*
     * @dev Sipariş bilgilerini tutmak için bir yapı.
     * @param musteri: Siparişi oluşturan müşterinin adresi.
     * @param postaKodu: Siparişin gönderileceği yerin posta kodu.
     * @param urunler: Sipariş edilen ürünlerin ID'lerinden oluşan bir liste.
     * @param durum: Siparişin mevcut durumu.
     */
    struct Siparis {
        address musteri;
        string postaKodu;
        uint256[] urunler;
        Durum durum;
    }
    
    // Tüm siparişlerin saklandığı bir dizi.
    Siparis[] public siparisler;
    
    // Kontrat sahibinin adresi.
    address public sahip;
    
    // Kontrat üzerinden gerçekleştirilen toplam işlem sayısı.
    uint256 public islemSayisi;

    /**
     * @dev Sipariş oluşturulduğunda tetiklenen olay.
     * @param siparisId: Yeni oluşturulan siparişin ID'si.
     * @param musteri: Siparişi oluşturan müşterinin adresi.
     */
    event SiparisOlusturuldu(uint256 siparisId, address indexed musteri);

    /**
     * @dev Posta kodu güncellendiğinde tetiklenen olay.
     * @param siparisId: Posta kodu güncellenen siparişin ID'si.
     * @param postaKodu: Güncellenmiş posta kodu.
     */
    event PostaKoduDegisti(uint256 siparisId, string postaKodu);

    /**
     * @dev Kontrat oluşturucu. Kontratı dağıtan adresi sahip olarak ayarlar.
     */
    constructor() {
        sahip = msg.sender;
    }

    /**
     * @dev Yeni bir sipariş oluşturur.
     * @param _postaKodu: Siparişin gönderileceği posta kodu.
     * @param _urunler: Sipariş edilen ürünlerin ID'lerinden oluşan liste.
     * @return Yeni oluşturulan siparişin ID'si.
     */
    function siparisOlustur(string memory _postaKodu, uint256[] memory _urunler) 
        islemArtir 
        urunKontrol(_urunler) 
        external 
        returns (uint256) 
    {
        Siparis memory yeniSiparis;
        yeniSiparis.musteri = msg.sender;
        yeniSiparis.postaKodu = _postaKodu;
        yeniSiparis.urunler = _urunler;
        yeniSiparis.durum = Durum.Alindi;

        siparisler.push(yeniSiparis);

        emit SiparisOlusturuldu(siparisler.length - 1, msg.sender);

        return siparisler.length - 1;
    }

    /**
     * @dev Bir siparişin durumunu bir sonraki aşamaya ilerletir.
     * @param _siparisId: İlerletilecek siparişin ID'si.
     */
    function siparisIlerle(uint256 _siparisId) 
        siparisKontrol(_siparisId) 
        sadeceSahip 
        public 
    {
        Siparis storage siparis = siparisler[_siparisId];
        require(siparis.durum != Durum.Kargolandi, "Siparis zaten kargolandi.");

        if (siparis.durum == Durum.Alindi) {
            siparis.durum = Durum.Hazirlaniyor;
        } else if (siparis.durum == Durum.Hazirlaniyor) {
            siparis.durum = Durum.Paketlendi;
        } else if (siparis.durum == Durum.Paketlendi) {
            siparis.durum = Durum.Kargolandi;
        }
    }

    /**
     * @dev Bir siparişin detaylarını döndürür.
     * @param _siparisId: Detayları döndürülecek siparişin ID'si.
     * @return İstenen siparişin detayları.
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
     * @dev Bir siparişin posta kodunu günceller.
     * @param _siparisId: Posta kodu güncellenecek siparişin ID'si.
     * @param _posta: Yeni posta kodu.
     */
    function postaKoduGuncelle(uint256 _siparisId, string memory _posta) 
        sadeceMusteri(_siparisId) 
        islemArtir 
        siparisKontrol(_siparisId) 
        external 
    {        
        Siparis storage siparis = siparisler[_siparisId];
        siparis.postaKodu = _posta;

        emit PostaKoduDegisti(_siparisId, _posta);
    }

    // === Modifier'lar ===

    /**
     * @dev Ürünlerin boş olmadığını kontrol eden bir modifier.
     */
    modifier urunKontrol(uint256[] memory _urunler) {
        require(_urunler.length > 0, "Urun yok.");
        _;
    }

    /**
     * @dev Geçerli bir sipariş ID'si olup olmadığını kontrol eden bir modifier.
     */
    modifier siparisKontrol(uint256 _siparisId) {
        require(_siparisId < siparisler.length, "Gecerli bir siparis ID'si degil.");
        _;
    }

    /**
     * @dev İşlem sayısını artıran bir modifier.
     */
    modifier islemArtir {
        _;
        islemSayisi++;
    }

    /**
     * @dev Sadece kontrat sahibinin erişebileceği işlemleri kontrol eden bir modifier.
     */
    modifier sadeceSahip {
        require(msg.sender == sahip, "Yetkiniz yok.");
        _;
    }

    /**
     * @dev Sadece siparişin sahibi tarafından erişilebilecek işlemleri kontrol eden bir modifier.
     * @param _siparisId: İşlem yapılacak siparişin ID'si.
     */
    modifier sadeceMusteri(uint256 _siparisId) {
        require(siparisler[_siparisId].musteri == msg.sender, "Siparisin sahibi degilsiniz.");
        _;
    }
}
