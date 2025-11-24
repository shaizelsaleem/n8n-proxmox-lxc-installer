# Example XML News Files

This directory contains sample XML news files for testing the news bulletin workflow.

## Supported XML Formats

### 1. RSS 2.0 Format
```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>News Agency Feed</title>
    <description>Latest news updates</description>
    <link>https://example.com/news</link>
    <language>en</language>
    <lastBuildDate>Mon, 25 Nov 2024 10:00:00 GMT</lastBuildDate>
    
    <item>
      <title>Breaking: Major Technology Breakthrough</title>
      <description>Scientists announce a revolutionary advancement in quantum computing that promises to transform data processing capabilities worldwide.</description>
      <link>https://example.com/news/tech-breakthrough</link>
      <pubDate>Mon, 25 Nov 2024 09:30:00 GMT</pubDate>
      <category>Technology</category>
      <category>Science</category>
    </item>
    
    <item>
      <title>Local Elections Results Announced</title>
      <description>City officials release final results from yesterday's municipal elections with record voter turnout reported.</description>
      <link>https://example.com/news/elections</link>
      <pubDate>Mon, 25 Nov 2024 08:45:00 GMT</pubDate>
      <category>Politics</category>
      <category>Local</category>
    </item>
  </channel>
</rss>
```

### 2. Custom News Format
```xml
<?xml version="1.0" encoding="UTF-8"?>
<news>
  <header>
    <source>International News Agency</source>
    <timestamp>2024-11-25T10:00:00Z</timestamp>
    <version>1.0</version>
  </header>
  
  <articles>
    <article>
      <id>ART-001</id>
      <title>Global Climate Summit Reaches Historic Agreement</title>
      <summary>World leaders commit to ambitious new targets for carbon reduction following intensive negotiations.</summary>
      <content>Detailed article content goes here...</content>
      <published>2024-11-25T09:15:00Z</published>
      <category>Environment</category>
      <category>Politics</category>
      <priority>High</priority>
    </article>
    
    <article>
      <id>ART-002</id>
      <title>Stock Markets Reach Record Highs</title>
      <summary>Major indices surge as investors react positively to economic indicators and corporate earnings reports.</summary>
      <content>Detailed article content goes here...</content>
      <published>2024-11-25T08:30:00Z</published>
      <category>Business</category>
      <category>Finance</category>
      <priority>Medium</priority>
    </article>
  </articles>
</news>
```

### 3. Atom Feed Format
```xml
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>News Feed</title>
  <subtitle>Latest updates</subtitle>
  <link href="https://example.com/feed"/>
  <updated>2024-11-25T10:00:00Z</updated>
  <author>
    <name>News Agency</name>
  </author>
  <id>https://example.com/</id>
  
  <entry>
    <title>Sports Championship Finals This Weekend</title>
    <link href="https://example.com/sports/finals"/>
    <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
    <updated>2024-11-25T09:00:00Z</updated>
    <summary>Tickets selling fast as championship finals approach with teams making final preparations.</summary>
    <category term="Sports"/>
  </entry>
</feed>
```

## File Naming Convention

Place your XML news files in the `xml_news_wires/` directory with the following naming convention:

- **Date-based**: `YYYY-MM-DD_news.xml`
- **Source-based**: `source_name_YYYY-MM-DD.xml`
- **Category-based**: `category_news_YYYY-MM-DD.xml`

Examples:
- `2024-11-25_tech_news.xml`
- `reuters_2024-11-25.xml`
- `sports_news_2024-11-25.xml`

## Media References

XML files can include media references:

```xml
<item>
  <title>News with Media</title>
  <description>News description</description>
  <enclosure url="https://example.com/image.jpg" type="image/jpeg"/>
  <media:content url="https://example.com/video.mp4" type="video/mp4"/>
</item>
```

## Testing Files

The following sample files are included for testing:

1. **sample_news.xml** - Basic RSS format with multiple news items
2. **tech_news.xml** - Technology-focused news items
3. **local_news.xml** - Local community news

Create additional test files following the formats above to test different scenarios.