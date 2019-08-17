# Pandas Hızlı Notlar

## Dosyadan Verileri Okuma

Detaylar için [Pandas dökümanına](https://pandas.pydata.org/pandas-docs/stable/user_guide/io.html) bakabilirsin.

| Uzantı | Açıklama               | Açılımı         |
| ------ | ---------------------- | --------------- |
| `csv`  | `,` ile ayrılan notlar | Comma delimeted |
| `tsv`  | `\t` ile ayırma        | Tab delimeted   |

```py
import pandas as pd

# Basit olarak csv okuma
pd.read_csv(<path_to_csv>)

# Satırı atlayarak csv okuma
pd.read_csv(<path_to_csv>, skiprows=[1])

# Başlangıç indeksi belirleme
pd.read_csv(<path_to_csv>, index_col=0)

# Başlıksız verileri okuma
pd.read_csv(<path_to_csv>, names=<list>, header=None)

# Tab ile ayrılan verileri okuma
pd.read_csv(<path_to_tsv>, delimiter='\t')
```

<details>
<summary>Csv okuma yöntemleri</summary>

```py
csv = [','.join(map(lambda x: str(x), row)) for row in np.vstack([df.columns, df])]
with open('./data/read_csv_example.csv', 'w') as f:
    [f.write(line + '\n') for line in csv]

!cat ./data/read_csv_example.csv
```

![](../res/ex_ilkel_csv.png)

```py
pd.read_csv('./data/read_csv_example.csv')
```

![](../res/ex_pandas_read.png)

</details>

## Verileri Filtreleme

| Operatör              | Açıklama                 |
| --------------------- | ------------------------ |
| `~`                   | not                      |
| `&`                   | and                      |
| `|`                   | or                       |
| `str.contains(<str>)` | String'e göre filtreleme |

```py
df = pd.DataFrame()

# Verinin en tepesini gösterme
df.head()

# Koşulun sağlandığı verileri alma
df = df[df['state'] == 'AZ']

# Eşsiz verileri alma
df['state'].unique()

# Birden fazla koşula göre alma
# `()` kullanımlaıdır yoksa `&` işlemi beklendiği gibi çalışmaz
df[(df['state'] == 'AZ') & (df['review_count'] > 10)].head()

# Koşulun sonucuna göre `True - False` dizisi döndürür
(yelp_df['state'] == 'AZ').head()
(yelp_df['state'] == 'AZ').dtype # dtype('bool')

# El ile seçme (1. indexteki elemanı almaz)
df[[True, False, True]]

# Bool değeri alan sütuna göre listeleme (open = {True | False})
df[df['open']].head() # Açık olanları listeler
df[~df['open']].head() # Kapalı olanları listeler `~ = !`
df[df['open'].fillna(False)].head() # Nan değerlerini false sayarak listeleme

# Strig'e göre filtreleme (`vegas` içeren şehirleri alma)
df = df[df['city'].str.contains('Vegas')]
```

## Fonksiyonlar ve Birleştirme İşlemleri

```py
# Log hesaplaması (her veri için log alır)
log_review_count = np.log(df['review_count'])

# Ortalama hesaplama (tek değer döndürür)
mean_review_count = yelp_df['review_count'].mean()

# DB'ye fonksiyon uygulama (parametre olarak `df['attributes']` almak zorundadır)
# True - False serisi döndürür
delivery_attr = df['attributes'].apply(<func_attr_dict>)
```

## GroupBy Kullanımı

Belirli bir öğeye göre gruplar, çakışanlara verilen işlemi uygular.

- Örn: `max()`, `mean()` gibi metodlarda en yüksek veya ortalama alınır

> [Group By: split-apply-combine](https://pandas.pydata.org/pandas-docs/stable/user_guide/groupby.html) dökümanına bakmanda fayda var.

```py
# Şehre göre birleştirme ve yıldızların ortalamasını alma
stars_by_city = yelp_df.groupby('city')['stars'].mean()

# Şehre göre gruplayıp, çakışan verilerde birden fazla metod kullanma
# Sırayla: Stars sütunu altında: ortalama, standart sapma, diğer sütunlarda toplam, miktar
agg_by_city = yelp_df.groupby('city').agg({'stars': {'mean': 'mean', 'std': 'std'}, 'review_count': 'sum', 'business_id': 'count'})

# Birleştirilmiş sütunları ayırma
new_columns = map(lambda x: '_'.join(x),
                  zip(agg_by_city.columns.get_level_values(0),
                      agg_by_city.columns.get_level_values(1)))
agg_by_city.columns = new_columns
agg_by_city.head()

# Gruplanmış verileri index dict'ine  çevirme
dict_city = by_city.groups

# Gruplanmış verilerden bir tanesini alma
by_city.get_group('Anthem').head()
```

## Sıralama İşlemleri

```py
# Yıldızlara göre veriyi sıralama
df.sort_values('stars').head()

# Bussiness_id'nin indexine göre sıralama
df.set_index('business_id').sort_index().head()
```

## Veri Kümelerinin Birleştirilmesi

```py
# Şehir ve bölge olarak verileir ayırma
census['city'] = census['GEO.display-label'].apply(lambda x: x.split(', ')[0])
census['state'] = census['GEO.display-label'].apply(lambda x: x.split(', ')[2])

# Bölge isiimlerini değiştirme
state_abbr = dict(zip(census['state'].unique(), <list>))
census['state'] = census['state'].replace(state_abbr)
```

<details>
<summary>Dataset</summary>

![](../res/city_dataset_ex.png)

</details>
