use nogame_fixed::f128::core::{abs, exp, ln};
// use nogame_fixed::f128::math::core::{ln, abs, exp};
use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

/// A Linear Variable Rate Gradual Dutch Auction (VRGDA) struct.
/// Represents an auction where the price decays linearly based on the target price,
/// decay constant, and per-time-unit rate.
#[derive(Copy, Drop, Serde, starknet::Storage)]
struct LinearVRGDA {
    target_price: Fixed,
    decay_constant: Fixed,
    per_time_unit: Fixed,
}

#[generate_trait]
impl LinearVRGDAImpl of LinearVRGDATrait {
    /// Calculates the target sale time based on the quantity sold.
    ///
    /// # Arguments
    ///
    /// * `sold`: Quantity sold.
    ///
    /// # Returns
    ///
    /// * A `Fixed` representing the target sale time.
    fn get_target_sale_time(self: @LinearVRGDA, sold: Fixed) -> Fixed {
        sold / *self.per_time_unit
    }

    /// Calculates the VRGDA price at a specific time since the auction started.
    ///
    /// # Arguments
    ///
    /// * `time_since_start`: Time since the auction started.
    /// * `sold`: Quantity sold.
    ///
    /// # Returns
    ///
    /// * A `Fixed` representing the price.
    fn get_vrgda_price(self: @LinearVRGDA, time_since_start: Fixed, sold: Fixed) -> Fixed {
        *self.target_price
            * exp(
                *self.decay_constant
                    * (time_since_start
                        - self.get_target_sale_time(sold + FixedTrait::new(1, false)))
            )
    }

    fn get_reverse_vrgda_price(self: @LinearVRGDA, time_since_start: Fixed, sold: Fixed) -> Fixed {
        *self.target_price
            * exp(
                (*self.decay_constant * FixedTrait::new(1, true))
                    * (time_since_start
                        - self.get_target_sale_time(sold + FixedTrait::new(1, false)))
            )
    }
}


#[derive(Copy, Drop, Serde, starknet::Storage)]
struct LogisticVRGDA {
    target_price: Fixed,
    decay_constant: Fixed,
    max_sellable: Fixed,
    time_scale: Fixed,
}

// A Logistic Variable Rate Gradual Dutch Auction (VRGDA) struct.
/// Represents an auction where the price decays according to a logistic function,
/// based on the target price, decay constant, max sellable quantity, and time scale.
#[generate_trait]
impl LogisticVRGDAImpl of LogisticVRGDATrait {
    /// Calculates the target sale time using a logistic function based on the quantity sold.
    ///
    /// # Arguments
    ///
    /// * `sold`: Quantity sold.
    ///
    /// # Returns
    ///
    /// * A `Fixed` representing the target sale time.
    fn get_target_sale_time(self: @LogisticVRGDA, sold: Fixed) -> Fixed {
        let logistic_limit = *self.max_sellable + FixedTrait::ONE();
        let logistic_limit_double = logistic_limit * FixedTrait::new_unscaled(2, false);
        abs(
            ln(logistic_limit_double / (sold + logistic_limit) - FixedTrait::ONE())
                / *self.time_scale
        )
    }

    /// Calculates the VRGDA price at a specific time since the auction started,
    /// using the logistic function.
    ///
    /// # Arguments
    ///
    /// * `time_since_start`: Time since the auction started.
    /// * `sold`: Quantity sold.
    ///
    /// # Returns
    ///
    /// * A `Fixed` representing the price.
    fn get_vrgda_price(self: @LogisticVRGDA, time_since_start: Fixed, sold: Fixed) -> Fixed {
        *self.target_price
            * exp(
                *self.decay_constant
                    * (time_since_start
                        - self.get_target_sale_time(sold + FixedTrait::new(1, false)))
            )
    }

    fn get_reverse_vrgda_price(
        self: @LogisticVRGDA, time_since_start: Fixed, sold: Fixed
    ) -> Fixed {
        *self.target_price
            * exp(
                (*self.decay_constant * FixedTrait::new(1, true))
                    * (time_since_start
                        - self.get_target_sale_time(sold + FixedTrait::new(1, false)))
            )
    }
}

const _0_31: u128 = 5718490662849961000;
const _0_10: u128 = 3689348814741911000;
const PRICE: u128 = 221360928884514600;
const PRECISION: u128 = 1_000_000_000_000_000_000;

#[test]
fn test_auction_price_increasing() {
    let auction = LinearVRGDA {
        target_price: FixedTrait::new(PRICE, false),
        decay_constant: FixedTrait::new(_0_10, true),
        per_time_unit: FixedTrait::new_unscaled(10, false),
    };

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 11999999999999998,
        'wrong assert # 1'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(11, false)).mag
            * PRECISION
            / ONE == 14952920766475353,
        'wrong assert # 2'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(20, false)).mag
            * PRECISION
            / ONE == 17901896371284823,
        'wrong assert # 3'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(30, false)).mag
            * PRECISION
            / ONE == 21865425604302498,
        'wrong assert # 4'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(40, false)).mag
            * PRECISION
            / ONE == 26706491141297844,
        'wrong assert # 5'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(50, false)).mag
            * PRECISION
            / ONE == 32619381940644807,
        'wrong assert # 6'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::new_unscaled(200, false)).mag
            * PRECISION
            / ONE == 655177800382777271,
        'wrong assert # 7'
    );
}

#[test]
fn test_auction_price_decreasing() {
    let auction = LinearVRGDA {
        target_price: FixedTrait::new(PRICE, false),
        decay_constant: FixedTrait::new(_0_10, true),
        per_time_unit: FixedTrait::new_unscaled(10, false),
    };

    assert(
        auction.get_vrgda_price(FixedTrait::ZERO(), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 11999999999999998,
        'wrong assert # 1'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::new_unscaled(1, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 9824769037297713,
        'wrong assert # 2'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::new_unscaled(2, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 8043840552612083,
        'wrong assert # 3'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::new_unscaled(3, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 6585739633243856,
        'wrong assert # 4'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::new_unscaled(4, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 5391947569530171,
        'wrong assert # 5'
    );

    assert(
        auction.get_vrgda_price(FixedTrait::new_unscaled(5, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 4414553294174200,
        'wrong assert # 6'
    );
    (
        auction.get_vrgda_price(FixedTrait::new_unscaled(6, false), FixedTrait::ZERO()).mag
            * PRECISION
            / ONE == 3614330543041306,
        'wrong assert # 7'
    );
}
