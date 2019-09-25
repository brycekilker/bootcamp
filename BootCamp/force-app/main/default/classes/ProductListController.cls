public with sharing class ProductListController {


    public Product2 selectedProduct {get; set;}
    public Asset selectedAsset {get; set;}
    public List<Product2> productList {get; set;}
    public List<Asset> assetList {get; set;}
    public Id recordId {get; set;}

    public ProductListController() {

        recordId = ApexPages.currentPage().getParameters().get('id');
        selectedProduct = new Product2();
        selectedAsset = new Asset();

        if(recordId != null) {
            selectedProduct = [
                SELECT Id, Name, Family
                FROM Product2
                WHERE Id = :recordId
            ];
        }
        fetchProducts();
    }

    public void fetchProducts() {

        productList = [
            SELECT Id, Name, Family
            FROM Product2
            ORDER BY Name DESC
            LIMIT 10
        ];
        System.debug('here are the prdoucts ' + productList);
    }

    public void populateProductForm() {
        selectedProduct = [
            SELECT Id, Name, Family
            FROM Product2
            WHERE Id = :selectedProduct.Id
        ];
        findAsset();
    }

    public void findAsset() {
        List<Asset> assetList = new List<Asset>();

        assetList = [
            SELECT Id, Description, Name, Product2.Name
            FROM Asset
            WHERE Product2Id = :selectedProduct.Id
        ];

        
        System.debug('is there a product? ' + selectedProduct);
        System.debug('I got the asset ' + assetList);
    }

    public void createAsset() {
        if(selectedAsset != null) {
            insert selectedAsset;
        }
    }
    
    public void clearForm(){
        selectedProduct = new Product2();
    }
}
