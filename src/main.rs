#[derive(Debug)]
struct Entry {
    prio: u8,
    pend: bool,
    enable: bool,
}

const NR: usize = 8;

fn get_entry<const N: usize>(nr_prio_bit: u8, entries: &[Entry; N]) -> usize {
    let nr_index_bits = (NR as u8).ilog2() as u8;

    let mut contenders = [(true, 0); N];
    for i in 0..N {
        contenders[i] = (
            entries[i].pend & entries[i].enable,
            (entries[i].prio << nr_index_bits) + i as u8,
        )
    }

    println!("{}", nr_index_bits);
    println!("{:?}", contenders);

    for bit in (0..nr_index_bits + nr_prio_bit).rev() {
        println!("bit {}", bit);
        let weight: u8 = 1 << bit;
        let mut or_value: u8 = 0;

        // compute the or among all contenders
        for (contend, value) in contenders {
            if contend {
                or_value |= value & weight;
            }
        }
        // update surviving contenders
        for (contend, value) in contenders.iter_mut() {
            if *value & weight != or_value & weight {
                *contend = false
            }
        }
        println!("contenders {:?}", contenders);
    }

    let mut result = None;
    for (i, (c, _)) in contenders.iter().enumerate() {
        if *c {
            match result {
                Some(j) => panic!("i {}, j {}", i, j),
                _ => result = Some(i),
            }
        }
    }
    result.unwrap()
}

fn main() {
    let entries = [
        // 0
        Entry {
            prio: 0b100,
            pend: true,
            enable: false,
        },
        // 1
        Entry {
            prio: 0b001,
            pend: true,
            enable: true,
        },
        // 2
        Entry {
            prio: 0b100,
            pend: true,
            enable: true,
        },
        // 3
        Entry {
            prio: 0b111,
            pend: false,
            enable: false,
        },
        // 4
        Entry {
            prio: 0b010,
            pend: true,
            enable: true,
        },
        // 5
        Entry {
            prio: 0b101,
            pend: true,
            enable: true,
        },
        // 6
        Entry {
            prio: 0b001,
            pend: false,
            enable: true,
        },
        // 7
        Entry {
            prio: 0b101,
            pend: true,
            enable: true,
        },
    ];

    let i = get_entry(3, &entries);
    println!("i is the winner {}", i);
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test5a() {
        let entries = [
            // 0
            Entry {
                prio: 0b100,
                pend: true,
                enable: false,
            },
            // 1
            Entry {
                prio: 0b001,
                pend: true,
                enable: true,
            },
            // 2
            Entry {
                prio: 0b100,
                pend: true,
                enable: true,
            },
            // 3
            Entry {
                prio: 0b111,
                pend: false,
                enable: false,
            },
            // 4
            Entry {
                prio: 0b010,
                pend: true,
                enable: true,
            },
            // 5, single highest prio
            Entry {
                prio: 0b101,
                pend: true,
                enable: true,
            },
            // 6
            Entry {
                prio: 0b001,
                pend: false,
                enable: true,
            },
            // 7
            Entry {
                prio: 0b100,
                pend: true,
                enable: true,
            },
        ];

        let i = get_entry(3, &entries);
        println!("i is the winner {}", i);
        assert_eq!(i, 5);
    }

    #[test]
    fn test5b() {
        let entries = [
            // 0
            Entry {
                prio: 0b100,
                pend: true,
                enable: false,
            },
            // 1
            Entry {
                prio: 0b001,
                pend: true,
                enable: true,
            },
            // 2
            Entry {
                prio: 0b101, // tie with 5
                pend: true,
                enable: true,
            },
            // 3
            Entry {
                prio: 0b111,
                pend: false,
                enable: false,
            },
            // 4
            Entry {
                prio: 0b101, // tie with 5
                pend: true,
                enable: true,
            },
            // 5
            Entry {
                prio: 0b101, // 5 wins
                pend: true,
                enable: true,
            },
            // 6
            Entry {
                prio: 0b001,
                pend: false,
                enable: true,
            },
            // 7
            Entry {
                prio: 0b100,
                pend: true,
                enable: true,
            },
        ];

        let i = get_entry(3, &entries);
        println!("i is the winner {}", i);
        assert_eq!(i, 5);
    }
}
