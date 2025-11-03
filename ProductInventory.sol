// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ProductInventory - A simple smart contract for managing product stock
/// @notice Supports product receiving, sales, and stock display operations
contract ProductInventory {
    // Structure to represent a Product
    struct Product {
        uint id;
        string name;
        uint quantity;
    }

    // Array to store products
    Product[] public products;

    // Mapping to quickly find product index by ID
    mapping(uint => uint) private productIndex;
    mapping(uint => bool) private productExists;

    // Events for transaction logging
    event ProductReceived(uint id, string name, uint quantity);
    event ProductSold(uint id, string name, uint quantity);

    /// @notice Receive new products into the inventory
    /// @param _id Unique product ID
    /// @param _name Product name
    /// @param _quantity Quantity received
    function receiveProduct(uint _id, string memory _name, uint _quantity) public {
        require(_quantity > 0, "Quantity must be greater than zero");

        // If product already exists, update quantity
        if (productExists[_id]) {
            uint index = productIndex[_id];
            products[index].quantity += _quantity;
        } else {
            // Otherwise, add as new product
            products.push(Product(_id, _name, _quantity));
            productIndex[_id] = products.length - 1;
            productExists[_id] = true;
        }

        emit ProductReceived(_id, _name, _quantity);
    }

    /// @notice Sell a product (reduce stock)
    /// @param _id Product ID
    /// @param _quantity Quantity sold
    function sellProduct(uint _id, uint _quantity) public {
        require(productExists[_id], "Product does not exist");
        require(_quantity > 0, "Quantity must be greater than zero");

        uint index = productIndex[_id];
        require(products[index].quantity >= _quantity, "Not enough stock");

        products[index].quantity -= _quantity;

        emit ProductSold(_id, products[index].name, _quantity);
    }

    /// @notice Display current stock of a specific product
    /// @param _id Product ID
    /// @return name Product name
    /// @return quantity Current available stock
    function getProductStock(uint _id) public view returns (string memory name, uint quantity) {
        require(productExists[_id], "Product does not exist");
        uint index = productIndex[_id];
        Product memory p = products[index];
        return (p.name, p.quantity);
    }

    /// @notice Get total number of products in inventory
    function getProductCount() public view returns (uint) {
        return products.length;
    }

    /// @notice Fallback function — handles invalid function calls
    fallback() external payable {
        revert("Invalid function called");
    }

    /// @notice Receive function — allows ETH to be sent (optional)
    receive() external payable {}
}
