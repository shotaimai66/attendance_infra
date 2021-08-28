resource "aws_route53_zone" "Route53HostedZone" {
    name = "${var.domain}."
}

resource "aws_route53_record" "Route53RecordSet" {
    name = "${var.domain}."
    type = "A"
    alias {
        name = "${aws_alb.alb.dns_name}"
        zone_id = "${aws_alb.alb.zone_id}"
        evaluate_target_health = true
    }
    zone_id = "${aws_route53_zone.Route53HostedZone.zone_id}"
}

resource "aws_route53_record" "Route53RecordSet4" {
    name = "_d6a804da669c00ccd8a12b797e0e9f43.${var.domain}."
    type = "CNAME"
    ttl = 300
    records = [
        "_6747aaa0a941ecd6735e7889da65753d.gxwgcdsjsl.acm-validations.aws."
    ]
    allow_overwrite = true
    zone_id = "${aws_route53_zone.Route53HostedZone.zone_id}"
}

resource "aws_acm_certificate" "cert" {
  # ワイルドカード証明書で同じドメイン内の複数のサイトを保護
  domain_name               = "*.${var.domain}"
  # ネイキッドドメインや apex ドメイン(ドメイン名そのもの)を保護
  subject_alternative_names = ["${var.domain}"]
  # ACMドメイン検証方法にDNS検証を指定
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  ttl = "300"

  # レコードを追加するドメインのホストゾーンIDを指定
  zone_id = "${aws_route53_zone.Route53HostedZone.zone_id}"
}
