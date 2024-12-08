// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructsAndEnums {
    /**
     * @dev Siparis durumlarini temsil eden enum.
     * Taken: Siparis alindi.
     * Preparing: Siparis hazirlaniyor.
     * Boxed: Siparis paketlendi.
     * Shipped: Siparis kargoya verildi.
     */
    enum Durum {
        Alindi,       // 0
        Hazirlaniyor, // 1
        Paketlendi,   // 2
        Kargolandi    // 3
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

    // Tum siparislerin saklandigi dizi.
    Siparis[] public siparisler;

    // Kontrat sahibinin adresi.
    address public sahip;

    /**
     * @dev Kontrat olusturucu, kontrati dagitan adresi sahip olarak atar.
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
        external
        returns (uint256)
    {
        require(_urunler.length > 0, "Urun yok.");

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
     * @dev Alternatif yolla yeni bir siparis olusturur.
     * @param _postaKodu Siparisin gonderilecegi posta kodu.
     * @param _urunler Siparis edilen urunlerin ID'lerinden olusan liste.
     * @return Olusturulan siparisin ID'si.
     */
    function siparisOlustur2(string memory _postaKodu, uint256[] memory _urunler)
        external
        returns (uint256)
    {
        require(_urunler.length > 0, "Urun yok.");

        siparisler.push(
            Siparis({
                musteri: msg.sender,
                postaKodu: _postaKodu,
                urunler: _urunler,
                durum: Durum.Alindi
            })
        );

        return siparisler.length - 1;
    }

    /**
     * @dev Alternatif yolla siparis olusturma (daha kısa).
     */
    function siparisOlustur3(string memory _postaKodu, uint256[] memory _urunler)
        external
        returns (uint256)
    {
        require(_urunler.length > 0, "Urun yok.");
        siparisler.push(Siparis(msg.sender, _postaKodu, _urunler, Durum.Alindi));
        return siparisler.length - 1;
    }

    /**
     * @dev Bir siparisin durumunu bir sonraki asamaya ilerletir.
     * @param _siparisId Ilerletilecek siparisin ID'si.
     */
    function siparisIlerle(uint256 _siparisId) public {
        require(msg.sender == sahip, "Yetkiniz yok.");
        require(_siparisId < siparisler.length, "Gecerli bir siparis ID'si degil.");

        Siparis storage siparis = siparisler[_siparisId];
        require(siparis.durum != Durum.Kargolandi, "Siparis zaten kargoya verildi.");

        if (siparis.durum == Durum.Alindi) {
            siparis.durum = Durum.Hazirlaniyor;
        } else if (siparis.durum == Durum.Hazirlaniyor) {
            siparis.durum = Durum.Paketlendi;
        } else if (siparis.durum == Durum.Paketlendi) {
            siparis.durum = Durum.Kargolandi;
        }
    }

    /**
     * @dev Belirli bir siparisin bilgilerini getirir.
     * @param _siparisId Bilgileri alinacak siparisin ID'si.
     * @return Siparis bilgileri.
     */
    function siparisGetir(uint256 _siparisId) external view returns (Siparis memory) {
        require(_siparisId < siparisler.length, "Gecerli bir siparis ID'si degil.");
        return siparisler[_siparisId];
    }

    /**
     * @dev Bir siparisin posta kodunu gunceller.
     * @param _siparisId Posta kodu guncellenecek siparisin ID'si.
     * @param _posta Yeni posta kodu.
     */
    function postaKoduGuncelle(uint256 _siparisId, string memory _posta) external {
        require(_siparisId < siparisler.length, "Gecerli bir siparis ID'si degil.");
        Siparis storage siparis = siparisler[_siparisId];
        require(siparis.musteri == msg.sender, "Siparisin sahibi degilsiniz.");
        siparis.postaKodu = _posta;
    }
}
