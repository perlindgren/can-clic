#[derive(Debug)]
struct Entry {
    priority: u32,
    pend: bool,
    enable: bool,
}

fn get_entry(
    threshold: u32,
    current_priority: u32,
    nr_prio_bit: u32,
    entries: &Vec<Entry>,
) -> Option<usize> {
    let nr_index_bits = (entries.len() + 1).ilog2() as u32 + 1;

    println!(
        "entries_len {}, nr_index_bits {}",
        entries.len(),
        nr_index_bits
    );

    let mut contenders: Vec<_> = entries
        .iter()
        .enumerate()
        .map(|(i, e)| (e.enable & e.pend, i as u32 + (e.priority << nr_index_bits)))
        .collect();

    contenders.push((true, (threshold << nr_index_bits) + entries.len() as u32));
    contenders.push((
        true,
        (current_priority << nr_index_bits) + entries.len() as u32 + 1,
    ));

    println!("Initial state \n{:?}\n\nArbitration started", contenders);

    for bit in (0..nr_index_bits + nr_prio_bit).rev() {
        let weight: u32 = 1 << bit;
        let mut or_value: u32 = 0;
        println!("bit {} weight {}", bit, weight);

        // compute the or among all contenders
        for (contend, value) in &contenders {
            if *contend {
                or_value |= *value & weight;
            }
        }
        // update surviving contenders
        for (contend, value) in contenders.iter_mut() {
            if *value & weight != or_value & weight {
                *contend = false
            }
        }
        println!("{:?}", contenders);
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

    result = match result {
        Some(i) => {
            if i >= entries.len() {
                None
            } else {
                result
            }
        }
        None => result,
    };

    println!(
        "threshold {} current_priority {}, i is the winner {:?}",
        threshold, current_priority, result,
    );
    result
}

fn main() {
    let entries = vec![
        // 000
        Entry {
            priority: 0b100,
            pend: true,
            enable: false,
        },
        // 001
        Entry {
            priority: 0b001,
            pend: true,
            enable: true,
        },
        // 010
        Entry {
            priority: 0b100,
            pend: true,
            enable: true,
        },
        // 011
        Entry {
            priority: 0b111,
            pend: false,
            enable: false,
        },
        // 100
        Entry {
            priority: 0b010,
            pend: true,
            enable: true,
        },
        // 101
        Entry {
            priority: 0b101,
            pend: true,
            enable: true,
        },
        // 110
        Entry {
            priority: 0b001,
            pend: false,
            enable: true,
        },
        // 111
        Entry {
            priority: 0b101,
            pend: true,
            enable: true,
        },
    ];

    let _i = get_entry(0, 0, 3, &entries);
    let _i = get_entry(4, 0, 3, &entries);
    let _i = get_entry(0, 4, 3, &entries);
    let _i = get_entry(5, 4, 3, &entries);
    let _i = get_entry(5, 5, 3, &entries);
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test5a() {
        let entries = vec![
            // 0
            Entry {
                priority: 0b100,
                pend: true,
                enable: false,
            },
            // 1
            Entry {
                priority: 0b001,
                pend: true,
                enable: true,
            },
            // 2
            Entry {
                priority: 0b100,
                pend: true,
                enable: true,
            },
            // 3
            Entry {
                priority: 0b111,
                pend: false,
                enable: false,
            },
            // 4
            Entry {
                priority: 0b010,
                pend: true,
                enable: true,
            },
            // 5, single highest prio
            Entry {
                priority: 0b101,
                pend: true,
                enable: true,
            },
            // 6
            Entry {
                priority: 0b001,
                pend: false,
                enable: true,
            },
            // 7
            Entry {
                priority: 0b100,
                pend: true,
                enable: true,
            },
        ];

        let i = get_entry(0, 0, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, Some(5));

        let i = get_entry(4, 0, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, Some(5));
        let i = get_entry(0, 4, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, Some(5));
        let i = get_entry(4, 4, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, Some(5));
        let i = get_entry(4, 5, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, None);
    }

    #[test]
    fn test5c() {
        let entries = vec![
            // 0
            Entry {
                priority: 0b100,
                pend: true,
                enable: false,
            },
            // 1
            Entry {
                priority: 0b101,
                pend: true,
                enable: true,
            },
            // 2
            Entry {
                priority: 0b101, // win over 1
                pend: true,
                enable: true,
            },
            // 3
            Entry {
                priority: 0b111,
                pend: false,
                enable: false,
            },
        ];

        let i = get_entry(0, 0, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, Some(2));
        let i = get_entry(5, 0, 3, &entries);
        println!("i is the winner {:?}", i);
        assert_eq!(i, None);
    }
}
