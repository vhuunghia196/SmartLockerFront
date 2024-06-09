// import node module libraries
import { Col, Row, Card } from 'react-bootstrap';
import { getUserCookie } from 'utils/auth'

const AboutMe = () => {
    const user = getUserCookie();
    const gmail = user.email;
    const phone = user.phone;
    const name = user.name;
    return (

            <Card>
                {/* card body */}
                <Card.Body>
                    {/* card title */}
                    <Card.Title as="h2">Giới thiệu</Card.Title>
                    <Row>
                        <Col xs={6}>
                            <h6 className="text-uppercase fs-5 ls-2">Họ và tên </h6>
                            <p className="mb-0">{name}</p>
                        </Col>
                        <Col xs={6} className="mb-5">
                            <h6 className="text-uppercase fs-5 ls-2">Số điện thoại </h6>
                            <p className="mb-0">{phone}</p>
                        </Col>
                        <Col xs={6}>
                            <h6 className="text-uppercase fs-5 ls-2">Email </h6>
                            <p className="mb-0">{gmail}</p>
                        </Col>
                    </Row>
                </Card.Body>
            </Card>
    )
}

export default AboutMe